### 运行stvo

```sh
export DATASETS_DIR=/mnt/hgfs/dataset/EuRoC/MH_01_easy/
cd build
./imagesStVO mav0 -c ../config/config/config_euroc.yaml
```

### evo工具

```sh
evo_traj tum traj.txt --save_as_kitti
evo_traj kitti traj.kitti --ref=00.txt -p --align --plot_mode=xz
evo_traj tum point+line.txt --ref=data.tum -p --align --plot_mode=xz
evo_traj tum point+line.txt point+line2.txt point+line3.txt --ref=GT.txt -p --align --plot_mode=xy
evo_rpe tum point+line.txt GT.txt -p --align
```

