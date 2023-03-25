defmodule CraftingTasksWeb.TaskControllerTest do
  use CraftingTasksWeb.ConnCase, async: true

  describe "tasks" do
    test "generate sorted tasks for empty list ", %{conn: conn} do
      conn = post(conn, ~p"/api/tasks/sort", %{"tasks" => []})
      assert json_response(conn, 200)["tasks"] == []
    end

    test "generate sorted tasks for no deps list ", %{conn: conn} do
      no_deps = %{"tasks" => [%{"name" => "task1", "command" => "ls -lrt"}, %{"name" => "task2", "command" => "whoami"}, %{"name" => "task3", "command" => "cd"}]}
      conn = post(conn, ~p"/api/tasks/sort",no_deps)
      tasks = json_response(conn, 200)["tasks"]
      assert length(tasks) == 3

      assert tasks == no_deps["tasks"]
    end

    test "generate sorted tasks list ", %{conn: conn} do
      payload = %{"tasks" => [
        %{"command" => "cat /tmp/file1", "name" => "task-2", "requires" => ["task-3"]},
        %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-3", "requires" => ["task-1"]},
        %{"command" => "rm /tmp/file1", "name" => "task-4", "requires" => ["task-2", "task-3"]},
        %{"command" => "touch /tmp/file1", "name" => "task-1"}
      ]}

      correct_order = [
        %{"command" => "touch /tmp/file1", "name" => "task-1"},
        %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-3", "requires" => ["task-1"]},
        %{"command" => "cat /tmp/file1", "name" => "task-2", "requires" => ["task-3"]},
        %{"command" => "rm /tmp/file1", "name" => "task-4", "requires" => ["task-2", "task-3"]}
      ]

      conn = post(conn, ~p"/api/tasks/sort",payload)
      tasks = json_response(conn, 200)["tasks"]
      assert length(tasks) == 4

      assert tasks == correct_order

      conn = post(conn, ~p"/api/tasks/script",payload)
      tasks_script = text_response(conn, 200)
      assert tasks_script == "#!/usr/bin/env bash\ntouch /tmp/file1\necho 'Hello World!' > /tmp/file1\ncat /tmp/file1\nrm /tmp/file1"
    end

    test "generate wrong format ", %{conn: conn} do
      conn = post(conn, ~p"/api/tasks/sort", %{"tasks" => %{}})
      assert json_response(conn, 200)["tasks"] == []
    end
  end
end
