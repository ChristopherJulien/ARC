# Isaac Gym Envs Learning Pipeline
(Adapted by Christopher Julien Stocker) 

Author: Filip Bjelonic <filipb@leggedrobotics.com>

Co-Author: Jonas Frey <jonfrey@leggedrobotics.com>

**How to setup learning pipeline on cluster**

We assume that you went through the following presentation that describes how the ETH cluster works:

https://docs.google.com/presentation/d/1y3iSIHqS2lKfDFyogOT1a8iEr3RIxxNjOJfKGM-5LAI/edit?usp=sharing

[Getting Started with the ETH Cluster](https://docs.google.com/presentation/d/1y3iSIHqS2lKfDFyogOT1a8iEr3RIxxNjOJfKGM-5LAI/edit?usp=sharing)

To access the cluster, you need to be connect to the ETH network or use the CISCO VPN to ETH.

You can run your training at Euler cluster.  
You can check the documents [here](https://scicomp.ethz.ch/wiki/Main_Page).

This is a guide about how to run the [isaac_gym_envs](https://github.com/NVIDIA-Omniverse/IsaacGymEnvs) code on the cluster.

Some info.  
- [batch system](https://scicomp.ethz.ch/wiki/Using_the_batch_system)  
- [Euler](https://scicomp.ethz.ch/wiki/Euler)  

## Get Started

Please check the presentation to create an account, setup SSH keys, and request access to the RSL group.


## Setting up dependencies on the cluster

Switch to lmod system (add to .bashrc):
```bash
env2lmod
```

Load modules:
```bash
module load sdl2/2.0.5 ffmpeg/3.2.4 eigen/3.3.4 cmake/3.16.5 python/3.8.5 gcc/8.2.0 cuda/11.4.2 vim/8.1.1746 eth_proxy boost
```

Save modules for next time:
```bash
module save
```

### Install docker and singularity
At the cluster, you need to use singularity as your container.
You can build isaacgym container and send it to the cluster.

Install singularity. Currently(2022/09/01), euler has the version of 3.8.7-1.el7.
Install at least 3.x version to your PC.

Also, install docker. This is because the isaac_gym_envs singularity container is built from docker image.

### Installing issacgym and isaac_gym_envs on your machine
Please follow the steps on [isaac_gym_envs](https://github.com/NVIDIA-Omniverse/IsaacGymEnvs/blob/main/README.md) repo.
Namely, install the repo isaacgym from Nvidia and clone the repos rsl_rl and legged_gym into this directory /home/<username>/isaac_ws/
```bash
mkdir ~/issac_ws
```
Here, you can clone the three repos. Replace \<user\> by your cluster username (same as eth username) 
 ! Warning this will work to download rls_rl, legged_gym, and isaac_gym, but not isaac_gym_ens this must be done manually through git.
```bash
echo "export EULER_USER=<user>" >> ~/.bashrc
```

### Build singularity container on your machine
Build the docker container first.  
Just execute the `build.sh` script in `legged_gym/containers/docker`
```bash
cd ~/isaac_ws/isaac_gym_envs
```
```bash
./containers/docker/build.sh
```
Then, build the singularity container.
```bash
./containers/singularity/build.sh
```
It will generate `isaac_gym_envs.sif` in the folder containers/singularity

### Move container to Cluster
First, you need to pass the container to the cluster.
You can use either scp or rsync. First compress using tar into a single file.

On Cluster:
```bash
mkdir -p /cluster/work/rsl/$USER/logs
echo "export WORK=/cluster/work/rsl/$USER" >> ~/.bashrc
```
This is where you will leave your permanent container to run isaac_gym_envs on the cluster.
Further, the logs folder will be used for logging the training process.

On your PC:
```bash
cd ~/isaac_ws/isaac_gym_envs/containers/singularity
tar -cvf isaac_gym_envs.tar isaac_gym_envs.sif
sudo scp isaac_gym_envs.tar $EULER_USER@euler.ethz.ch:/cluster/work/rsl/$EULER_USER
```

On the cluster (only necessary for debugging the singularity container on the cluster,
  otherwise, this step can be skipped):
```bash
tar -xf $WORK/isaac_gym_envs.tar -C $SCRATCH
```

## Running your training script inside container
Create and clone git folders (do not try to install them):


ACCESS YOUR OWN GIT REPO OR EVENTUALLY ARCS ISAAC_GYM_ENVS REPO
```bash
cd $HOME
mkdir git && cd git
git clone git@[YOUR_REPO]
```

### Running on GPU
You can use the train.sh provided in the isaac_gym_envs repo (containers/bin) to submit a job to the cluster.
This is a simple starting point to get going. I recommend writing nice submission scripts in the early stage to save time later.

You can select the queue from 4h, 24h, and 120h.
Note that 120h might take a long waiting time.

Please check the cluster document for further information.
