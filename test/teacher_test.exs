defmodule TeacherTest do
  use ExUnit.Case
  doctest Teacher

  test "greets the world" do
    assert Teacher.hello() == :world
  end
end
