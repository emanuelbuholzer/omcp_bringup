import os

from ament_index_python import get_package_share_directory
from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import PathJoinSubstitution
from launch_ros.substitutions import FindPackagePrefix


def generate_launch_description():
    declared_arguments = []

    omcp_blender_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            [
                os.path.join(get_package_share_directory("omcp_blender"), "launch"),
                "/omcp_blender.launch.py",
            ]
        ),
        launch_arguments={}.items(),
    )
    declared_arguments.append(omcp_blender_launch)

    return LaunchDescription(declared_arguments)
