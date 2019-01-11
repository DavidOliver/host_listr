id = 4

Benchee.run(
  %{
    "process_list"        => fn -> HostListr.Lists.process_list(id) end,
    # "process_list_stream" => fn -> HostListr.Lists.process_list_stream(id) end,
    "process_list_flow"   => fn -> HostListr.Lists.process_list_flow(id) end,
  },
  parallel: 1,
  console: [extended_statistics: true]
)
