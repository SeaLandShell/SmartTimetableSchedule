#!/bin/bash
TARGET='./mainfest'

# 复制目录结构及其文件到目标目录
copy_directory_structure() {
  local source_dir="$1"
  local target_dir="$2"

  # 检查目标目录是否存在，如果不存在则创建
  if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
  fi

  # 遍历源目录中的所有条目
  for entry in "$source_dir"/*; do
    # 获取条目名称
    entry_name=$(basename "$entry")

    # 如果是目录，递归调用
    if [ -d "$entry" ]; then
      copy_directory_structure "$entry" "$TARGET"
    else
      # 如果是文件，直接复制
      cp "$entry" "$TARGET"
    fi
  done
}

move_all() {
  # 调用函数，复制 ./deploy-yaml 到 ./manifest
  copy_directory_structure "./" "$TARGET"
}

deploy() {
  files=$(ls -lh $TARGET | awk '{print $9}')
  for file in ${files}; do
    echo "${file}"
    IFS='.' read -ra FILE_PARTS <<< "${file}"
    first_part="${FILE_PARTS[0]}"
    second_part="${FILE_PARTS[1]}"
    # 检查 second_part 是否为 "yaml"
    if [ "$second_part" = "yaml" ]; then
      kubectl apply -f "${TARGET}/${file}"
    fi
  done
}

replace_dp() {
  files=$(ls -lh $TARGET | awk '{print $9}')
  for file in ${files}; do
    echo "${file}"
    IFS='.' read -ra FILE_PARTS <<< "${file}"
    first_part="${FILE_PARTS[0]}"
    second_part="${FILE_PARTS[1]}"
    # 检查 second_part 是否为 "yaml"
    if [ "$second_part" = "yaml" ]; then
      kubectl replace -f "${TARGET}/${file}"
    fi
  done
}

delete_all() {
  files=$(ls -lh $TARGET | awk '{print $9}')
  for file in ${files}; do
    echo "${file}"
    IFS='.' read -ra FILE_PARTS <<< "${file}"
    first_part="${FILE_PARTS[0]}"
    second_part="${FILE_PARTS[1]}"
    # 检查 second_part 是否为 "yaml"
    if [ "$second_part" = "yaml" ]; then
      kubectl delete -f "${TARGET}/${file}" --ignore-not-found
    fi
  done
}

# 根据输入命令执行相应操作
case $1 in
"move_all")
  move_all
  ;;
"deploy")
  deploy
  ;;
"replace_dp")
  replace_dp
  ;;
"delete_all")
  delete_all
  ;;
*)
  # 默认输出帮助信息
  echo "未找到命令$1，命令执行格式："
  echo "deploy.sh command"
  echo "command: {move_all,deploy,replace_dp,delete_all}"
  echo "move_all: 移动所有部署文件到mainfest目录"
  echo "deploy: k8s部署"
  echo "replace_dp: k8s重新部署"
  echo "delete_all: k8s删除本项目所有资源"
  ;;
esac