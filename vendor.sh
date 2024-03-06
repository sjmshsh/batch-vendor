#!/bin/bash

# 根目录路径
root_dir="./"

# 创建一个存放压缩文件的文件夹
mkdir zip_dir

# 遍历根目录下的文件夹
for dir in "$root_dir"/*; do
	# 检查是否为文件夹
	if [ -d "$dir" ]; then
		# 获取文件夹的名字
		fn=$(basename "$dir")
		echo "正在执行: "$fn""
		# 进入文件夹并且执行命令
		cd "$fn"
		# 确保项目的依赖是最新状态
		go mod tidy
		# 使用vendor打包依赖
		go mod vendor
		# 删除mod和sum文件
		rm -rf go.mod
		rm -rf go.sum
		# 重建 go.mod 文件
		go mod init code.byted.org/motor/"$fn"
		cd ..
		# 打包成tar文件
		tar -czf "$fn".tgz "$fn"
		mv ./"$fn".tgz ./zip_dir/"$fn".tgz
	fi
done
