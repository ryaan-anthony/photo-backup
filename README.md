# photo-backup

### Prerequisites
```bash
export STORAGE_PROJECT=XXXXXXXXXX
export STORAGE_BUCKET=XXXXXXXXXX
export STORAGE_CREDENTIALS=XXXXXXXXXX
export CLIENT_ID=XXXXXXXXXX
export CLIENT_SECRET=XXXXXXXXXX
export REFRESH_TOKEN=XXXXXXXXXX
```

### Run console
```bash
bundle exec irb -I . -r lib/bootstrap.rb
```

### Run using local ruby
```bash
bundle exec lib/photo_backup.rb
```

### Run using docker

Build the container
```bash
docker-compose up --build --detach
```

View the logs
```bash
tail -f event.log
```
