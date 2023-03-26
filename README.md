# CraftingTasks

## Startup

Build docker image

```bash
docker build --no-cache -t crafting/tasks .
```

Start the container

```bash
docker run -e SECRET_KEY_BASE=test -e PHX_HOST=0.0.0.0 -e PHX_SERVER=true -p4000:4000 crafting/tasks
```

## Endpoints 
- /api/tasks/sort  sorting the tasks to create a proper execution order.
- /api/tasks/script returns bash script representation 

### Example
```bash
curl --location --request POST 'localhost:4000/api/tasks/sort' \
--header 'Content-Type: application/json' \
--data-raw '{
  "tasks": [
    {
      "name": "task-1",
      "command": "touch /tmp/file1"
    },
    {
      "name": "task-2",
      "command":"cat /tmp/file1",
      "requires":[
        "task-3"
      ]
    },
    {
      "name": "task-3",
      "command": "echo '\''Hello World!'\'' > /tmp/file1",
      "requires":[
       "task-1"
      ]
    },
    {
      "name": "task-4",
      "command": "rm /tmp/file1",
      "requires":[
        "task-2",
        "task-3"
      ]
    }
  ]
}'
```
```bash
curl --location --request POST 'localhost:4000/api/tasks/script' \
--header 'Content-Type: application/json' \
--data-raw '{
  "tasks": [
    {
      "name": "task-1",
      "command": "touch /tmp/file1"
    },
    {
      "name": "task-2",
      "command":"cat /tmp/file1",
      "requires":[
        "task-3"
      ]
    },
    {
      "name": "task-3",
      "command": "echo '\''Hello World!'\'' > /tmp/file1",
      "requires":[
       "task-1"
      ]
    },
    {
      "name": "task-4",
      "command": "rm /tmp/file1",
      "requires":[
        "task-2",
        "task-3"
      ]
    }
  ]
}'
```