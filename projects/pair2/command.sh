#!/usr/bin/env bash

# Pair 2 ids
FOLLOWER_ID="gix-follower2"
LEADER_ID="gix-leader2"

# Fill these in after checking ports
FOLLOWER_PORT="/dev/ttyACM0"
LEADER_PORT="/dev/ttyACM1"

# Configure motors
# lerobot-setup-motors --robot.type=so101_follower --robot.port="${FOLLOWER_PORT}"
# lerobot-setup-motors --teleop.type=so101_leader --teleop.port="${LEADER_PORT}"

# Calibrate follower
# lerobot-calibrate \
#   --robot.type=so101_follower \
#   --robot.port="${FOLLOWER_PORT}" \
#   --robot.id="${FOLLOWER_ID}"

# Calibrate leader
# lerobot-calibrate \
#   --teleop.type=so101_leader \
#   --teleop.port="${LEADER_PORT}" \
#   --teleop.id="${LEADER_ID}"

# Backup calibration files here after calibration succeeds
# cp /home/ubuntu/.cache/huggingface/lerobot/calibration/robots/so101_follower/${FOLLOWER_ID}.json /home/ubuntu/techin517/projects/pair2/
# cp /home/ubuntu/.cache/huggingface/lerobot/calibration/teleoperators/so101_leader/${LEADER_ID}.json /home/ubuntu/techin517/projects/pair2/
