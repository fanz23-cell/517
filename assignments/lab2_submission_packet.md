# Lab 2 Submission Packet

Name: `________________`

Date: `2026-04-15`

Course Lab: `Lab 2: Lerobot Ex ROS`

Note:
This packet intentionally leaves out the video link because it is submitted separately.
The reflection paragraph about controller trade-offs is also intentionally left for the student to write manually because the assignment says not to use AI for that part.

## 1. Rosetta Contract

```yaml
robot_type: soa

fps: 30 # change if you used a different fps for training
max_duration_s: 15.0

observations:
  # Wrist USB cam -> model's observation.images.wrist
  - key: observation.images.wrist
    topic: /follower/image_raw
    type: sensor_msgs/msg/Image
    image:
      resize: [480, 640]
    align: {strategy: hold, stamp: header}
    qos: {reliability: best_effort, history: keep_last, depth: 10}

  # Overhead RealSense RGB -> model's observation.images.overhead
  - key: observation.images.overhead
    topic: /static_camera/overhead_cam/color/image_raw
    type: sensor_msgs/msg/Image
    image:
      resize: [720, 1280]
    align: {strategy: hold, stamp: header}
    qos: {reliability: best_effort, history: keep_last, depth: 10}

  # Joint states: 6 joints from follower arm
  # Order MUST match training data index order
  # rad2deg: ROS radians -> model degrees
  - key: observation.state
    topic: /follower/joint_states
    type: sensor_msgs/msg/JointState
    selector:
      names:
        - position.shoulder_pan
        - position.shoulder_lift
        - position.elbow_flex
        - position.wrist_flex
        - position.wrist_roll
        - position.gripper
    align: {strategy: hold, stamp: header}
    qos: {reliability: best_effort, history: keep_last, depth: 50}
    unit_conversion: rad2deg

actions:
  # Arm ForwardCommandController: 5 arm joints -> Float64MultiArray
  # rad2deg on actions applies INVERSE (deg->rad) before publishing
  - key: action
    publish:
      topic: /follower/arm_fwd_controller/commands
      type: std_msgs/msg/Float64MultiArray
      qos: {reliability: reliable, history: keep_last, depth: 10}
    selector:
      names:
        - position.shoulder_pan
        - position.shoulder_lift
        - position.elbow_flex
        - position.wrist_flex
        - position.wrist_roll
    unit_conversion: rad2deg
    safety_behavior: hold

  # Gripper ForwardCommandController: 1 gripper joint -> Float64MultiArray
  - key: action
    publish:
      topic: /follower/gripper_fwd_controller/commands
      type: std_msgs/msg/Float64MultiArray
      qos: {reliability: reliable, history: keep_last, depth: 10}
    selector:
      names:
        - position.gripper
    unit_conversion: rad2deg
    safety_behavior: hold

recording:
  storage: mcap
```

## 2. Model And Task

- Trained run: `act_so101_2cam_v3-20260416T004131Z-3-002`
- Deployment model path:
  `/home/ubuntu/techin517/act_so101_2cam_v3-20260416T004131Z-3-002/act_so101_2cam_v3/checkpoints/last/pretrained_model`
- Task prompt:
  `grab the aruco and put it on the yellow basket`
- Camera setup:
  wrist camera + overhead Intel RealSense

## 3. Commands Used

### Bring up the robot in forward-controller mode

```bash
cd /home/ubuntu/techin517
source /opt/ros/humble/setup.bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 launch soa_bringup soa_bringup.launch.py controller:=forward cameras:=true
```

### Start the controller switch service

```bash
cd /home/ubuntu/techin517
source /opt/ros/humble/setup.bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 run soa_functions controller_switcher
```

### Start Rosetta with the ACT policy

```bash
cd /home/ubuntu/techin517
source /opt/ros/humble/setup.bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 launch rosetta rosetta_client_launch.py \
  contract_path:=/home/ubuntu/techin517/ros2_ws/src/soa_ros2/soa_bringup/rosetta_contracts/soa_act_contract.yaml \
  pretrained_name_or_path:=/home/ubuntu/techin517/act_so101_2cam_v3-20260416T004131Z-3-002/act_so101_2cam_v3/checkpoints/last/pretrained_model
```

### Run the policy

```bash
cd /home/ubuntu/techin517
source /opt/ros/humble/setup.bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 action send_goal /run_policy \
  rosetta_interfaces/action/RunPolicy \
  "{prompt: 'grab the aruco and put it on the yellow basket'}"
```

## 4. Controller Switching Commands

### List controllers

```bash
cd /home/ubuntu/techin517
source /opt/ros/humble/setup.bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 control list_controllers --controller-manager /follower/controller_manager
```

### Switch from forward controllers to joint trajectory controllers

```bash
cd /home/ubuntu/techin517
source /opt/ros/humble/setup.bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 control switch_controllers \
  --controller-manager /follower/controller_manager \
  --deactivate arm_fwd_controller gripper_fwd_controller \
  --activate arm_controller gripper_controller
```

### Switch back from joint trajectory controllers to forward controllers

```bash
cd /home/ubuntu/techin517
source /opt/ros/humble/setup.bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 control switch_controllers \
  --controller-manager /follower/controller_manager \
  --deactivate arm_controller gripper_controller \
  --activate arm_fwd_controller gripper_fwd_controller
```

### Switch controllers using the Lab 2 service

```bash
cd /home/ubuntu/techin517
source /opt/ros/humble/setup.bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 service call /controller_switcher/switch_controller \
  soa_interfaces/srv/SwitchController \
  "{controller_type: forward}"
```

```bash
cd /home/ubuntu/techin517
source /opt/ros/humble/setup.bash
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 service call /controller_switcher/switch_controller \
  soa_interfaces/srv/SwitchController \
  "{controller_type: jtc}"
```

## 5. Video Link

https://drive.google.com/file/d/1OsM2ZlLQ8uVritTBjHpV-IHZaXtttfN4/view?usp=sharing

## 6. Reflection Paragraph

To be written by student without AI, per assignment instructions.
