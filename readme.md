# tfenv を使うこと

https://qiita.com/kamatama_41/items/ba59a070d8389aab7694

# .terraform.lock.hcl について

# CIDR について

VPC の DICR は 172.16.0.0/16 を利用
https://note.com/takashi_sakurada/n/n502fb0299938

# リソースタイプの命名について

以下に従う
https://docs.aws.amazon.com/ja_jp/config/latest/developerguide/resource-config-reference.html#amazonelasticcomputecloud

# EC2 Instance Connect Endpoint の作り方

https://qiita.com/inugami_sayo/items/16b0cec096c22fdd905b
https://dev.classmethod.jp/articles/ec2-instance-connect-endpoint-by-terraform/

# user 　 data の確認

- 実行ログ
  cat /var/log/cloud-init-output.log

- 以下で生成されるファイル part-001 を管理者権限で実行すれば、イケる。
  cd /var/lib/cloud/instance/scripts

- httpd
  https://blog.s-giken.net/350.html
  systemctl status httpd

- エラーが出てうまくいかない
  https://github.com/aws/aws-cdk/issues/28518
  Running module scripts-user (<module 'cloudinit.config.cc_scripts_user' from '/usr/lib/python3.9/site-packages/cloudinit/config/cc_scripts_user.py'>) failed
