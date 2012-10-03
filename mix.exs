defmodule Cage.Mixfile do
  use Mix.Project

  def project do
    [ app: :cage,
      version: "0.0.1",
      deps: deps,
      env: [test: [deps: deps_test]]
    ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  defp deps do
    []
  end

  defp deps_test do
   [
    { :ranch, %r(.*), github: "extend/ranch"},
    { :cowboy, %r(.*), github: "extend/cowboy"},  
   ]
  end
end
