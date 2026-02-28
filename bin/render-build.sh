set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
bundle exec rails runner "User.where(share_uid: nil).find_each { |u| u.update!(share_uid: SecureRandom.alphanumeric(10)) }"
bundle exec rails db:seed