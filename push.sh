#!/bin/bash

# 目标仓库地址
TARGET_REPO="test-qj-registry.cn-hangzhou.cr.aliyuncs.com"

# 获取所有goharbor相关的镜像，然后通过循环逐个进行处理
docker images | grep goharbor | while read -r image tag rest
do
    source_image="$image:$tag"
    target_image="$TARGET_REPO/$image:$tag"
    
    echo "处理镜像: $source_image"

    # Tag 操作
    echo "正在标记 $source_image 到 $target_image"
    docker tag "$source_image" "$target_image"

    # Push 操作
    echo "正在推送 $target_image"
    docker push "$target_image"

    echo "完成 $source_image"
done

echo "所有goharbor相关镜像已被推送至 $TARGET_REPO."
