# Lab 2 Submission Prep

## Status

- Lab 1 policy training is complete.
- Trained run for this submission:
  `act_so101_2cam_v3-20260416T004131Z-3-002`
- Preferred model artifact for Lab 2:
  `act_so101_2cam_v3-20260416T004131Z-3-002/act_so101_2cam_v3/checkpoints/last/pretrained_model`
- Stable mirror path also available:
  `outputs/train/act_so101_2cam_v3/checkpoints/last/pretrained_model`
- Matching exported run folder observed in workspace:
  `act_so101_2cam_v3-20260416T004131Z-3-002/act_so101_2cam_v3/checkpoints/last`
- Training setup matched here:
  - robot pair: first leader/follower pair only
  - wrist image key: `observation.images.wrist` at `640x480`
  - overhead image key: `observation.images.overhead` at `1280x720`
  - state/action size: `6`
  - task: `grab the aruco and put it on the yellow basket`

## 1. Rosetta Contract

Use this file in your report:
[soa_act_contract.yaml](/home/ubuntu/techin517/ros2_ws/src/soa_ros2/soa_bringup/rosetta_contracts/soa_act_contract.yaml)

## 2. Commands Used

### Bring up the robot in forward-controller mode

```bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 launch soa_bringup soa_bringup.launch.py controller:=forward cameras:=true
```

### Start the controller switch service

```bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 run soa_functions controller_switcher
```

### Start Rosetta with your trained ACT model

```bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 launch rosetta rosetta_client_launch.py \
  contract_path:=/home/ubuntu/techin517/ros2_ws/src/soa_ros2/soa_bringup/rosetta_contracts/soa_act_contract.yaml \
  pretrained_name_or_path:=/home/ubuntu/techin517/act_so101_2cam_v3-20260416T004131Z-3-002/act_so101_2cam_v3/checkpoints/last/pretrained_model
```

### Run the policy

```bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 action send_goal /run_policy \
  rosetta_interfaces/action/RunPolicy \
  "{prompt: 'grab the aruco and put it on the yellow basket'}"
```

### Switch controllers from the command line

List controllers:

```bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 control list_controllers --controller-manager /follower/controller_manager
```

Switch from forward controllers to joint trajectory controllers:

```bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 control switch_controllers \
  --controller-manager /follower/controller_manager \
  --deactivate arm_fwd_controller gripper_fwd_controller \
  --activate arm_controller gripper_controller
```

Switch back from joint trajectory controllers to forward controllers:

```bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 control switch_controllers \
  --controller-manager /follower/controller_manager \
  --deactivate arm_controller gripper_controller \
  --activate arm_fwd_controller gripper_fwd_controller
```

### Switch controllers through your Lab 2 service

```bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 service call /controller_switcher/switch_controller \
  soa_interfaces/srv/SwitchController \
  "{controller_type: forward}"
```

```bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 service call /controller_switcher/switch_controller \
  soa_interfaces/srv/SwitchController \
  "{controller_type: jtc}"
```

Note:
If you launch `controller_switcher` inside the `/follower` namespace, the fully-qualified service name becomes:
`/follower/controller_switcher/switch_controller`

## 3. What You Still Need To Capture

- A video link showing:
  - the ROS 2 terminal
  - the Rosetta client terminal
  - the robot autonomously running the ACT policy
- The non-AI paragraph required by the assignment about controller trade-offs

## 4. Suggested Submission Packet

- `rosetta contract`:
  paste the contents of `soa_act_contract.yaml`
- `video link`:
  paste your recording URL
- `controller switching commands`:
  use the command block above
- `short reflection paragraph`:
  write this yourself to comply with the assignment rule

## 5. Files To Submit / Reference

- Report source notes:
  [lab2_submission.md](/home/ubuntu/techin517/lab2_submission.md)
- Rosetta contract to paste into the report:
  [soa_act_contract.yaml](/home/ubuntu/techin517/ros2_ws/src/soa_ros2/soa_bringup/rosetta_contracts/soa_act_contract.yaml)
- Controller switching service implementation:
  [controller_switcher.py](/home/ubuntu/techin517/ros2_ws/src/soa_ros2/soa_functions/soa_functions/controller_switcher.py)
- Clean command reference:
  [docker/command.sh](/home/ubuntu/techin517/docker/command.sh)

## 6. Quick Run Order

1. `source` your ROS workspace.
2. Launch `soa_bringup`.
3. Launch `controller_switcher`.
4. Launch `rosetta_client`.
5. Send `/run_policy`.
6. Record the robot and terminals for the deliverable video.
