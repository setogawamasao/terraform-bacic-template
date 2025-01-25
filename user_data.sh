#!/bin/bash

# -x to display the command to be executed
set -xe

# 実行したいコマンド関数化
my_command() {
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  usermod -a -G apache ec2-user
  chown -R ec2-user:apache /var/www
  chmod 2775 /var/www
  find /var/www -type d -exec chmod 2775 {} \;
  find /var/www -type f -exec chmod 0664 {} \;
  echo "Hello World" > /var/www/html/index.html
}

# 引数で指定したコマンドをリトライする関数
retry_command() {
    local retries=0     # リトライ回数のカウンター
    local max_retries=5 # リトライ回数の上限
    local sleep_time=5  # sleepする秒数
    local cmd=my_command

    # 実行したコマンドが失敗した場合、最大リトライ回数までリトライする
    while ! ${cmd}; do
        retries=$((retries + 1))
        if [[ "${retries}" > "${max_retries}" ]]; then
            echo "Maximum retry count ($max_retries) exceeded. Command execution failed."
            return 1
        fi
        echo "Command execution failed. Retrying attempt ${retries}..."
        sleep ${sleep_time}
    done

    echo "Command executed successfully."
    return 0
}

# リトライ関数を実行
retry_command