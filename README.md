# RubyBot
## Prerequisite
- Having Ruby Version >= 3.2.2 installed
## Setup
- Copy the `example.config.yml` to `config.yml`
- Replace `client_id` and `token` with your client id and token
- Create a simple sqlite database using the provided sql script in the sql directory
- Start the bot via one of the following commands:
```shell
# With JIT Support
ruby --yjit --yjit-exec-mem-size=16 lib/rubybot.rb
# Without JIT Support
ruby lib/rubybot.rb
```