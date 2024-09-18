defmodule FebrdBotWeb.ErrorJSONTest do
  use FebrdBotWeb.ConnCase, async: true

  test "renders 404" do
    assert FebrdBotWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert FebrdBotWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
