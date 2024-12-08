defmodule RafflefyWeb.PageController do
  use RafflefyWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
