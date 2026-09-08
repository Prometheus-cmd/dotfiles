#!/usr/bin/env python3
import argparse
import logging
import sys
import signal
import gi
gi.require_version('GLib', '2.0')
from gi.repository import GLib
import json

try:
    gi.require_version('PlayerCtl', '2.0')
    from gi.repository import PlayerCtl
except:
    pass

logger = logging.getLogger(__name__)

def write_output(text, player):
    logger.info('Writing output')

    output = {'text': text,
              'class': 'custom-' + player.props.player_name,
              'alt': player.props.player_name}

    sys.stdout.write(json.dumps(output) + '\n')
    sys.stdout.flush()

def on_metadata(player, metadata, manager):
    logger.info('Received new metadata')
    track_info = ''

    if player.props.status != PlayerCtl.PlaybackStatus.PLAYING:
        return

    if player.get_artist() != '' and player.get_title() != '':
        track_info = '{artist} — {title}'.format(
            artist=player.get_artist()[:20],
            title=player.get_title()[:25]
        )
    else:
        track_info = player.get_title()[:30]

    write_output(track_info, player)

def on_playback_status(player, status, manager):
    if status == PlayerCtl.PlaybackStatus.PLAYING:
        on_metadata(player, player.props.metadata, manager)
    else:
        clear_output()

def clear_output():
    sys.stdout.write('\n')
    sys.stdout.flush()

def on_player_appeared(manager, player, selected_player=None):
    if selected_player is None or player.props.player_name == selected_player:
        init_player(manager, player)

def on_player_vanished(manager, player):
    logger.info('Player has vanished')
    clear_output()

def init_player(manager, player):
    player.connect('playback-status', on_playback_status, manager)
    player.connect('metadata', on_metadata, manager)
    on_metadata(player, player.props.metadata, manager)

def signal_handler(sig, frame):
    logger.info('Received signal to stop, exiting')
    sys.stdout.write('\n')
    sys.stdout.flush()
    sys.exit(0)

def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--verbose', action='store_true')
    parser.add_argument('--player')
    parser.add_argument('--enable-logging', action='store_true')
    return parser.parse_args()

def main():
    arguments = parse_arguments()

    if arguments.enable_logging:
        logging.basicConfig(stream=sys.stderr,
                            level=logging.DEBUG if arguments.verbose else logging.WARN)

    manager = PlayerCtl.PlayerManager()
    loop = GLib.MainLoop()

    manager.connect('player-appeared', on_player_appeared, arguments.player)
    manager.connect('player-vanished', on_player_vanished)

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    for player in manager.props.player_names:
        if arguments.player is not None and arguments.player != player.props.player_name:
            logger.debug('Ignoring %s, only tracking %s', player.props.player_name,
                         arguments.player)
            continue
        logger.info('Tracking existing player: %s', player.props.player_name)
        init_player(manager, PlayerCtl.Player.new_from_name(player))

    loop.run()

if __name__ == '__main__':
    main()
