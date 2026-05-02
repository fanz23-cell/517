lerobot-teleoperate   --teleop.type=so101_leader   --teleop.port=/dev/ttyACM1   --teleop.id=gix-leader1   --robot.type=so101_follower   --robot.port=/dev/ttyACM0   --robot.id=gix-follower1   --display_data=false


lerobot-teleoperate \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM1 \
  --teleop.id=gix-leader1 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=gix-follower1 \
  --robot.cameras="{wrist: {type: opencv, index_or_path: /dev/video2, width: 640, height: 480, fps: 30}, overhead: {type: intelrealsense, serial_number_or_name: 348522076012, width: 1280, height: 720, fps: 30}}" \
  --display_data=false




    lerobot-record \
    --robot.type=bi_so100_follower \
    --robot.id=bimanual \
    --robot.calibration_dir=$FOLLOWER_CAL_DIR \
    --robot.left_arm_port=/dev/$FOLLOWER_USB \
    --robot.right_arm_port=/dev/$FOLLOWER2_USB \
    --robot.cameras='{ left_wrist: {type: opencv, index_or_path: /dev/video6, width: 640, height: 480, fps: 30, fourcc: MJPG}, right_wrist: {type: opencv, index_or_path: /dev/video8, width: 640, height: 480, fps: 30, fourcc: MJPG}, overhead: {type: intelrealsense, serial_number_or_name: 243222072732, width: 640, height: 480, fps: 30}}' \
    --teleop.type=bi_so100_leader \
    --teleop.id=bimanual_leader \
    --teleop.calibration_dir=$LEADER_CAL_DIR \
    --teleop.left_arm_port=/dev/$LEADER_USB \
    --teleop.right_arm_port=/dev/$LEADER2_USB \
    --dataset.repo_id=${HF_USER}/${RECORD_NAME} \
    --dataset.num_episodes=50 \
    --dataset.single_task="Turn a single page of a children's book." \
    --dataset.push_to_hub=False \
    --display_data=false \
    --play_sounds=false \
    --dataset.episode_time_s=120 \
    --dataset.reset_time_s=120 \
    --dataset.root=/home/ubuntu/techin517/outputs/record/${RECORD_NAME}




    token




    HF_USER=$(NO_COLOR=1 hf auth whoami | awk -F': *' 'NR==1 {print $2}')

lerobot-record \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM1 \
  --teleop.id=gix-leader1 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=gix-follower1 \
  --robot.cameras="{wrist: {type: opencv, index_or_path: /dev/video2, width: 640, height: 480, fps: 30}, overhead: {type: intelrealsense, serial_number_or_name: 348522076012, width: 1280, height: 720, fps: 30}}" \
  --dataset.repo_id=${HF_USER}/so101-30ep-2cam-v3 \
  --dataset.num_episodes=30 \
  --dataset.single_task="Grab the black cube" \
  --dataset.episode_time_s=10 \
  --dataset.reset_time_s=5 \
  --display_data=false


PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True lerobot-train \
  --dataset.repo_id=ubuntu/so101-30ep-2cam-v2 \
  --dataset.root=/home/ubuntu/.cache/huggingface/lerobot/ubuntu/so101-30ep-2cam-v2 \
  --policy.type=act \
  --policy.device=cuda \
  --policy.push_to_hub=false \
  --output_dir=outputs/train/act_so101_2cam_v2 \
  --job_name=act_so101_2cam_v2 \
  --wandb.mode=disabled \
  --batch_size=1 \
  --num_workers=0






sudo chmod 666 /dev/ttyACM0
sudo chmod 666 /dev/ttyACM1
sudo chmod 666 /dev/ttyACM2
sudo chmod 666 /dev/ttyACM3


lerobot-teleoperate \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM1 \
  --teleop.id=gix-leader1 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=gix-follower1 \
  --display_data=false


lerobot-teleoperate \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM3 \
  --teleop.id=gix-leader2 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM2 \
  --robot.id=gix-follower2 \
  --display_data=false


##### BI MANUAL TELEOPERATION

cp /home/ubuntu/.cache/huggingface/lerobot/calibration/teleoperators/so101_leader/gix-leader1.json \
  /home/ubuntu/.cache/huggingface/lerobot/calibration/teleoperators/so100_leader/bimanual_leader_left.json

cp /home/ubuntu/.cache/huggingface/lerobot/calibration/teleoperators/so101_leader/gix-leader2.json \
  /home/ubuntu/.cache/huggingface/lerobot/calibration/teleoperators/so100_leader/bimanual_leader_right.json

cp /home/ubuntu/.cache/huggingface/lerobot/calibration/robots/so101_follower/gix-follower1.json \
  /home/ubuntu/.cache/huggingface/lerobot/calibration/robots/so100_follower/bimanual_follower_left.json

cp /home/ubuntu/.cache/huggingface/lerobot/calibration/robots/so101_follower/gix-follower2.json \
  /home/ubuntu/.cache/huggingface/lerobot/calibration/robots/so100_follower/bimanual_follower_right.json


sudo chmod 666 /dev/ttyACM0
sudo chmod 666 /dev/ttyACM1
sudo chmod 666 /dev/ttyACM2
sudo chmod 666 /dev/ttyACM3

lerobot-teleoperate \
  --teleop.type=bi_so100_leader \
  --teleop.left_arm_port=/dev/ttyACM1 \
  --teleop.right_arm_port=/dev/ttyACM3 \
  --teleop.id=bimanual_leader \
  --robot.type=bi_so100_follower \
  --robot.left_arm_port=/dev/ttyACM0 \
  --robot.right_arm_port=/dev/ttyACM2 \
  --robot.id=bimanual_follower \
  --display_data=false



lerobot-record \
  --robot.type=bi_so100_follower \
  --robot.left_arm_port=/dev/ttyACM0 \
  --robot.right_arm_port=/dev/ttyACM2 \
  --robot.id=bimanual_follower \
  --robot.cameras="{left_wrist: {type: opencv, index_or_path: /dev/video2, width: 640, height: 480, fps: 30}, overhead: {type: intelrealsense, serial_number_or_name: 348522076012, width: 1280, height: 720, fps: 30}}" \
  --teleop.type=bi_so100_leader \
  --teleop.left_arm_port=/dev/ttyACM1 \
  --teleop.right_arm_port=/dev/ttyACM3 \
  --teleop.id=bimanual_leader \
  --dataset.repo_id=${HF_USER}/bimanual-so101-cleaner2 \
  --dataset.num_episodes=30 \
  --dataset.single_task="Bimanual manipulation task" \
  --dataset.episode_time_s=20 \
  --dataset.reset_time_s=5 \
  --display_data=false \

  --play_sounds=false




/dev/ttyACM0   leader2
  /dev/ttyACM1  leader1
/dev/ttyACM2   follower1
/dev/ttyACM3   follower2

sudo chmod 666 /dev/ttyACM0

lerobot-record \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.id=gix-follower1 \
  --robot.cameras='{"wrist": {"type": "opencv", "index_or_path": "/dev/video2", "width": 640, "height": 480, "fps": 30}, "overhead": {"type": "intelrealsense", "serial_number_or_name": "348522076012", "width": 1280, "height": 720, "fps": 30}}' \
  --dataset.repo_id=local/eval_act_so101_v1 \
  --dataset.num_episodes=1 \
  --dataset.single_task="grab the aruco and put it on the yellow basket" \
  --dataset.episode_time_s=15 \
  --dataset.reset_time_s=5 \
  --policy.type=act \
  --policy.pretrained_path=/home/ubuntu/techin517/outputs/train/act_so101_2cam_v3/checkpoints/last/pretrained_model \
  --dataset.push_to_hub=false \
  --display_data=false \
  --play_sounds=false


##### LAB 2: ROSETTA + ROS2_CONTROL

# Terminal 1: source workspace + bring up follower arm with forward controllers active
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 launch soa_bringup soa_bringup.launch.py controller:=forward cameras:=true

# Terminal 2: controller switch service
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 run soa_functions controller_switcher

# Terminal 3: Rosetta ACT policy client
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 launch rosetta rosetta_client_launch.py \
  contract_path:=/home/ubuntu/techin517/ros2_ws/src/soa_ros2/soa_bringup/rosetta_contracts/soa_act_contract.yaml \
  pretrained_name_or_path:=/home/ubuntu/techin517/outputs/train/act_so101_2cam_v3/checkpoints/last/pretrained_model

# Terminal 4: run policy goal
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 action send_goal /run_policy \
  rosetta_interfaces/action/RunPolicy \
  "{prompt: 'grab the aruco and put it on the yellow basket'}"

# Optional: inspect controllers
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 control list_controllers --controller-manager /follower/controller_manager

# Optional: switch controllers from CLI
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 control switch_controllers \
  --controller-manager /follower/controller_manager \
  --deactivate arm_fwd_controller gripper_fwd_controller \
  --activate arm_controller gripper_controller

source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 control switch_controllers \
  --controller-manager /follower/controller_manager \
  --deactivate arm_controller gripper_controller \
  --activate arm_fwd_controller gripper_fwd_controller

# Optional: switch controllers through the Lab 2 service
source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 service call /controller_switcher/switch_controller \
  soa_interfaces/srv/SwitchController \
  "{controller_type: forward}"

source /home/ubuntu/techin517/ros2_ws/install/setup.bash
ros2 service call /controller_switcher/switch_controller \
  soa_interfaces/srv/SwitchController \
  "{controller_type: jtc}"
