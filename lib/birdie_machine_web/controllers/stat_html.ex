defmodule BirdieMachineWeb.StatHTML do
  @moduledoc """
  This module contains pages rendered by StatController.

  See the `stat_html` directory for all templates available.
  """
  use BirdieMachineWeb, :html

  embed_templates "stat_html/*"
end
