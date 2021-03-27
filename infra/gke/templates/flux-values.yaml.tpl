git:
  url: ssh://git@github.com/loganrobertclemons/lrc-portfolio.git
  path: releases
  pollInterval: 5m
  user: loganrobertclemons
  email: loganrobertclemons@gmail.com
  secretName: flux-ssh
  label: flux
  branch: main
sync:
  state: git
  timeout: 1m
registry:
  disableScanning: true
syncGarbageCollection:
  enabled: true