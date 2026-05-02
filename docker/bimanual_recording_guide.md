# Bimanual Data Recording Checklist

This guide is for recording bimanual data with:

- `leader1 + follower1` as the left arm
- `leader2 + follower2` as the right arm
- `left_wrist + right_wrist + overhead` cameras

It covers:

1. checking which USB port belongs to which arm
2. checking which camera is which
3. testing left and right single-arm teleoperation
4. testing bimanual teleoperation
5. recording 2 test episodes
6. checking that the recording is complete
7. recording 100 final episodes

## Expected Mapping On This Machine

Latest confirmed mapping:

- `leader1 -> /dev/ttyACM0`
- `follower2 -> /dev/ttyACM1` (right arm)
- `follower1 -> /dev/ttyACM2` (left arm)
- `leader2 -> /dev/ttyACM3`

Latest confirmed camera mapping:

- right wrist camera:
  - `XWF-1080P (usb-0000:00:14.0-4) -> /dev/video8 /dev/video9`
- left wrist camera:
  - `XWF-1080P (usb-0000:00:14.0-13) -> /dev/video10 /dev/video11`
- integrated laptop camera:
  - `Integrated Camera -> /dev/video0 /dev/video1`
- top camera:
  - `Intel RealSense serial -> 348522076012`

Notes:

- `/dev/ttyACM*` and `/dev/video*` can change after reconnecting devices or rebooting.
- when the wrist cameras are connected, the main capture nodes have usually been `/dev/video8` and `/dev/video10`
- `/dev/video9` and `/dev/video11` are often not the main capture nodes

## 0. Re-check Arm Ports Before Starting

Most reliable method:

1. unplug all 4 arm USB connections
2. plug in only one device
3. run:

```bash
ls /dev/ttyACM*
lerobot-find-port
```

Repeat that for:

- `leader1`
- `follower2`
- `follower1`
- `leader2`

If the ports are the same as the latest check, you should get:

- `leader1 -> /dev/ttyACM0`
- `follower2 -> /dev/ttyACM1`
- `follower1 -> /dev/ttyACM2`
- `leader2 -> /dev/ttyACM3`

## 1. Re-check Camera Devices Before Starting

Run:

```bash
v4l2-ctl --list-devices
ls -l /dev/v4l/by-id
lerobot-find-cameras realsense
```

Confirm:

- right wrist camera is the `XWF-1080P` on `/dev/video8`
- left wrist camera is the `XWF-1080P` on `/dev/video10`
- overhead camera is the RealSense with serial `348522076012`
- do not substitute the laptop integrated camera for wrist recording unless you explicitly want a temporary debug setup

## 2. Give USB Permission To All Four Arms

```bash
sudo chmod 666 /dev/ttyACM0
sudo chmod 666 /dev/ttyACM1
sudo chmod 666 /dev/ttyACM2
sudo chmod 666 /dev/ttyACM3
```

## 3. Force Wrist Cameras Into Fixed Mode

```bash
v4l2-ctl --device=/dev/video10 --set-fmt-video=width=640,height=480,pixelformat=MJPG --set-parm=30
v4l2-ctl --device=/dev/video8 --set-fmt-video=width=640,height=480,pixelformat=MJPG --set-parm=30
```

## 4. Sync Single-Arm Calibration Into Bimanual Wrapper Names

Run this step:

- the first time you set up bimanual teleoperation
- any time you replace a motor
- any time you re-run `lerobot-calibrate` on `gix-follower1`, `gix-follower2`, `gix-leader1`, or `gix-leader2`

This is important because single-arm teleop uses:

- `gix-leader1`
- `gix-leader2`
- `gix-follower1`
- `gix-follower2`

but bimanual teleop uses the wrapper calibration files:

- `bimanual_leader_left`
- `bimanual_leader_right`
- `bimanual_follower_left`
- `bimanual_follower_right`

```bash
cp /home/ubuntu/.cache/huggingface/lerobot/calibration/teleoperators/so101_leader/gix-leader1.json \
  /home/ubuntu/.cache/huggingface/lerobot/calibration/teleoperators/so100_leader/bimanual_leader_left.json

cp /home/ubuntu/.cache/huggingface/lerobot/calibration/teleoperators/so101_leader/gix-leader2.json \
  /home/ubuntu/.cache/huggingface/lerobot/calibration/teleoperators/so100_leader/bimanual_leader_right.json

cp /home/ubuntu/.cache/huggingface/lerobot/calibration/robots/so101_follower/gix-follower1.json \
  /home/ubuntu/.cache/huggingface/lerobot/calibration/robots/so100_follower/bimanual_follower_left.json

cp /home/ubuntu/.cache/huggingface/lerobot/calibration/robots/so101_follower/gix-follower2.json \
  /home/ubuntu/.cache/huggingface/lerobot/calibration/robots/so100_follower/bimanual_follower_right.json
```

## 5. Test Left And Right Single-Arm Teleoperate First

Left arm: `leader1 -> follower1`

```bash
lerobot-teleoperate \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM0 \
  --teleop.id=gix-leader1 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM2 \
  --robot.id=gix-follower1 \
  --robot.cameras="{wrist: {type: opencv, index_or_path: /dev/video10, width: 640, height: 480, fps: 30}, overhead: {type: intelrealsense, serial_number_or_name: 348522076012, width: 1280, height: 720, fps: 30}}" \
  --display_data=false
```

Right arm: `leader2 -> follower2`

```bash
lerobot-teleoperate \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM3 \
  --teleop.id=gix-leader2 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.id=gix-follower2 \
  --robot.cameras="{wrist: {type: opencv, index_or_path: /dev/video8, width: 640, height: 480, fps: 30}, overhead: {type: intelrealsense, serial_number_or_name: 348522076012, width: 1280, height: 720, fps: 30}}" \
  --display_data=false
```

Pass criteria:

- left leader only controls left follower
- right leader only controls right follower
- both grippers open and close correctly
- wrist and top cameras do not error

## 6. Test Bimanual Teleoperate Without Cameras First

This is the fastest way to check whether both arm chains and the bimanual calibration files are correct.

```bash
lerobot-teleoperate \
  --teleop.type=bi_so100_leader \
  --teleop.left_arm_port=/dev/ttyACM0 \
  --teleop.right_arm_port=/dev/ttyACM3 \
  --teleop.id=bimanual_leader \
  --robot.type=bi_so100_follower \
  --robot.left_arm_port=/dev/ttyACM2 \
  --robot.right_arm_port=/dev/ttyACM1 \
  --robot.id=bimanual_follower \
  --display_data=false
```

Pass criteria:

- left leader controls left follower
- right leader controls right follower
- no crossed control
- both grippers work
- both arms move correctly even after a motor replacement

## 7. Test Bimanual Teleoperate With Cameras

After the no-camera test passes, add the cameras back:

```bash
lerobot-teleoperate \
  --teleop.type=bi_so100_leader \
  --teleop.left_arm_port=/dev/ttyACM0 \
  --teleop.right_arm_port=/dev/ttyACM3 \
  --teleop.id=bimanual_leader \
  --robot.type=bi_so100_follower \
  --robot.left_arm_port=/dev/ttyACM2 \
  --robot.right_arm_port=/dev/ttyACM1 \
  --robot.id=bimanual_follower \
  --robot.cameras="{left_wrist: {type: opencv, index_or_path: /dev/video10, width: 640, height: 480, fps: 30}, right_wrist: {type: opencv, index_or_path: /dev/video8, width: 640, height: 480, fps: 30}, overhead: {type: intelrealsense, serial_number_or_name: 348522076012, width: 1280, height: 720, fps: 30}}" \
  --display_data=false
```

Pass criteria:

- left leader controls left follower, right leader controls right follower
- no crossed control
- both grippers work
- all three camera streams work:
  - `left_wrist`
  - `right_wrist`
  - `overhead`

## 8. Record 2 Test Episodes First

```bash
TEST_RECORD_NAME=bimanual-cleaner2-test-v1

lerobot-record \
  --robot.type=bi_so100_follower \
  --robot.left_arm_port=/dev/ttyACM2 \
  --robot.right_arm_port=/dev/ttyACM1 \
  --robot.id=bimanual_follower \
  --robot.cameras="{left_wrist: {type: opencv, index_or_path: /dev/video10, width: 640, height: 480, fps: 30}, right_wrist: {type: opencv, index_or_path: /dev/video8, width: 640, height: 480, fps: 30}, overhead: {type: intelrealsense, serial_number_or_name: 348522076012, width: 1280, height: 720, fps: 30}}" \
  --teleop.type=bi_so100_leader \
  --teleop.left_arm_port=/dev/ttyACM0 \
  --teleop.right_arm_port=/dev/ttyACM3 \
  --teleop.id=bimanual_leader \
  --dataset.repo_id=local/${TEST_RECORD_NAME} \
  --dataset.root=/home/ubuntu/techin517/outputs/record/${TEST_RECORD_NAME} \
  --dataset.push_to_hub=false \
  --dataset.num_episodes=2 \
  --dataset.single_task="pick up the fruits with the cloth and place them into the basket" \
  --dataset.episode_time_s=20 \
  --dataset.reset_time_s=5 \
  --display_data=false \
  --play_sounds=false
```

## 9. Check That The 2 Test Episodes Are Complete

```bash
export TEST_RECORD_NAME=bimanual-cleaner2-test-v1

find /home/ubuntu/techin517/outputs/record/${TEST_RECORD_NAME} -maxdepth 3 -type d | sort
find /home/ubuntu/techin517/outputs/record/${TEST_RECORD_NAME}/meta/episodes -type f | sort
find /home/ubuntu/techin517/outputs/record/${TEST_RECORD_NAME}/data -type f | sort
find /home/ubuntu/techin517/outputs/record/${TEST_RECORD_NAME}/videos -type f | sort
find /home/ubuntu/techin517/outputs/record/${TEST_RECORD_NAME}/meta/episodes -type f | wc -l
```

If you open a new terminal and forget to re-set `TEST_RECORD_NAME`, the path will expand to:

```bash
/home/ubuntu/techin517/outputs/record//
```

and the `find` commands will fail even though the dataset is actually there.

Minimum things to confirm:

- `/home/ubuntu/techin517/outputs/record/${TEST_RECORD_NAME}` contains:
  - `data`
  - `videos`
  - `meta`
- `meta/episodes` contains 2 episode files
- `videos` contains files for:
  - `left_wrist`
  - `right_wrist`
  - `overhead`
- `data` is not empty

## 10. If The Test Set Looks Good, Record 100 Final Episodes

```bash
FINAL_RECORD_NAME=bimanual-cleaner2-100ep-v1

lerobot-record \
  --robot.type=bi_so100_follower \
  --robot.left_arm_port=/dev/ttyACM2 \
  --robot.right_arm_port=/dev/ttyACM1 \
  --robot.id=bimanual_follower \
  --robot.cameras="{left_wrist: {type: opencv, index_or_path: /dev/video10, width: 640, height: 480, fps: 30}, right_wrist: {type: opencv, index_or_path: /dev/video8, width: 640, height: 480, fps: 30}, overhead: {type: intelrealsense, serial_number_or_name: 348522076012, width: 1280, height: 720, fps: 30}}" \
  --teleop.type=bi_so100_leader \
  --teleop.left_arm_port=/dev/ttyACM0 \
  --teleop.right_arm_port=/dev/ttyACM3 \
  --teleop.id=bimanual_leader \
  --dataset.repo_id=local/${FINAL_RECORD_NAME} \
  --dataset.root=/home/ubuntu/techin517/outputs/record/${FINAL_RECORD_NAME} \
  --dataset.push_to_hub=false \
  --dataset.num_episodes=100 \
  --dataset.single_task="pick up the fruits with the cloth and place them into the basket" \
  --dataset.episode_time_s=20 \
  --dataset.reset_time_s=5 \
  --display_data=false \
  --play_sounds=false
```

## 11. Final Checks Before The 100-Episode Run

Check all 4 arm USB ports:

```bash
ls /dev/ttyACM*
```

Check left wrist, right wrist, and top camera:

```bash
v4l2-ctl --list-devices
lerobot-find-cameras realsense
```

If you get `FileExistsError`, do not overwrite the old dataset. Change:

- `TEST_RECORD_NAME`
- `FINAL_RECORD_NAME`

to a new version number.

If one of the wrist cameras throws another resolution error, rerun:

```bash
v4l2-ctl --device=/dev/video10 --set-fmt-video=width=640,height=480,pixelformat=MJPG --set-parm=30
v4l2-ctl --device=/dev/video8 --set-fmt-video=width=640,height=480,pixelformat=MJPG --set-parm=30
```

## 12. Delete A Failed Recording

If a recording failed and you want to remove the partially created dataset, delete the local folder for that dataset name.

Delete the failed 2-episode test dataset:

```bash
TEST_RECORD_NAME=bimanual-cleaner2-test-v1
rm -rf /home/ubuntu/techin517/outputs/record/${TEST_RECORD_NAME}
```

Delete the failed final dataset:

```bash
FINAL_RECORD_NAME=bimanual-cleaner2-100ep-v1
rm -rf /home/ubuntu/techin517/outputs/record/${FINAL_RECORD_NAME}
```

If you changed the dataset name, replace the variable value first, then run the same `rm -rf` command.
