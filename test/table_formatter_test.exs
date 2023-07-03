defmodule IssuesTableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter

  @simple_test_data [
    [c1: "r1 c1", c2: "r1 c2", c3: "r1 c3", c4: "r1+++c4"],
    [c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2 c4"],
    [c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3 c4"],
    [c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 c4"]
  ]

  @headers [:c1, :c2, :c4]

  def split_with_three_columns do
    TableFormatter.split_into_columns(@simple_test_data, @headers)
  end

  describe "split_into_columns/2" do
    test "split correctly" do
      columns = split_with_three_columns()
      assert length(columns) == length(@headers)
      assert List.first(columns) == ["r1 c1", "r2 c1", "r3 c1", "r4 c1"]
      assert List.last(columns) == ["r1+++c4", "r2 c4", "r3 c4", "r4 c4"]
    end
  end

  describe "widths_of/1" do
    test "it has correctly column widths" do
      widths = TableFormatter.widths_of(split_with_three_columns())
      assert widths == [5, 6, 7]
    end
  end

  describe "format_for/1" do
    test "format correctly" do
      assert TableFormatter.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
    end
  end

  describe "print_table_for_columns/2" do
    test "output correctly" do
      result =
        capture_io(fn -> TableFormatter.print_table_for_columns(@simple_test_data, @headers) end)

      assert result ==
               "c1    | c2     | c4     \n------+--------+--------\nr1 c1 | r1 c2  | r1+++c4\nr2 c1 | r2 c2  | r2 c4  \nr3 c1 | r3 c2  | r3 c4  \nr4 c1 | r4++c2 | r4 c4  \n"
    end
  end
end
