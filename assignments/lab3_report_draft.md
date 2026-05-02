# Lab 3 Report: MoveIt Forward Kinematics

Name: [Your Name]  
Date: [Due Date]

## 1. `save_joint_states` Service Code

File: `ros2_ws/src/soa_ros2/soa_functions/soa_functions/save_joint_states.py`

Paste the full code from that file here in your final report, or attach the file if your instructor accepts code separately.

## 2. Official ROS 2 Humble `JointState` Documentation

Official link:  
https://docs.ros.org/en/ros2_packages/humble/api/sensor_msgs/msg/JointState.html

## 3. Joint States CSV Contents

The CSV used for replay is shown below.

```csv
shoulder_pan,shoulder_lift,elbow_flex,wrist_flex,wrist_roll,gripper
0.28225246497095796,0.03834951969714103,0.4970097752749477,1.3054176504906807,0.1119805975156518,1.064582666792635
0.25310683000113077,0.35588354278946877,0.4740000634566631,1.038504993398579,0.15033011721279282,1.0630486860047492
0.25770877236478773,0.42184471666855133,0.3712233506683252,0.9648739155800683,0.1564660403643354,-0.04141748127291231
0.2945243112740431,0.019941750242513337,0.36968936988043954,0.9633399347921826,0.1564660403643354,-0.04141748127291231
-0.3328738309711841,0.0260776733940559,0.36968936988043954,0.9633399347921826,0.1564660403643354,-0.04141748127291231
-0.3052621767892426,0.0260776733940559,0.4172427743048944,0.9817477042468103,0.1564660403643354,1.141281706186917
```

If you end up replaying a different CSV file for the final demo, replace this block with the exact contents of the file you actually used.

## 4. `move_to_joint_states_server` Code

File: `ros2_ws/src/soa_ros2/soa_functions/soa_functions/move_to_joint_states_server.py`

Paste the full code from that file here in your final report, or attach the file if your instructor accepts code separately.

## 5. `go_to_joint_states` App Code

File: `ros2_ws/src/soa_ros2/soa_apps/soa_apps/go_to_joint_states.py`

Paste the full code from that file here in your final report, or attach the file if your instructor accepts code separately.

## 6. Video Link

Video link:  
https://drive.google.com/file/d/1yqEjMq4NHhN9RF0kOkIMBQMhMtr_qCAA/view?usp=sharing

## 7. Reflection

Forward kinematics is well suited for applications where the robot's joint values are known and we need to calculate the position and orientation of the end effector, such as robot simulation, motion playback, industrial automation, and simple pick-and-place tasks. One strength of controlling the joints directly is that it is straightforward, efficient, and easy to implement because each motor can be commanded independently. It also gives precise control over the robot's internal motion. However, the weakness is that joint control does not directly guarantee that the end effector will move to the desired position in task space, so it can be less intuitive for complex tasks. It also becomes harder to use when the robot must interact accurately with objects or environments, because small joint errors can lead to larger errors at the end effector.

## Submission Checklist

- `save_joint_states.py`
- official `JointState` documentation link
- CSV contents
- `move_to_joint_states_server.py`
- `go_to_joint_states.py`
- video link
- your own non-AI reflection paragraph
