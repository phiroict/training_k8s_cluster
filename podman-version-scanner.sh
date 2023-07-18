# https://docs.podman.io/en/latest/markdown/podman-images.1.html
IFS=$'\n'
IMAGES=($(podman images --format "{{.ID}} {{.Repository}}"))

# shellcheck disable=SC2066
for IMAGE in "${IMAGES[@]}"; do
  HASH=$(echo $IMAGE | cut -f 1 -d " ")
  NAME=$(echo $IMAGE | cut -f 2 -d " ")
  VERSION=$(podman inspect ${HASH} | jq '.[0].Labels.version' --raw-output)
  if [[ ! "${VERSION}" =~ "null" ]]; then
    echo "podman inspect ${HASH} | jq '.[0].Labels.Version' for image ${NAME} has version ${VERSION}"
  fi

done
