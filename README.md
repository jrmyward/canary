# Canary

Canary is a Ruby gem CLI program that initiates activity and records associated telemetry in a log
file. The program will:

    - Start a process given an executable file and the desired (optional) command-line arguments
    - Create a file given a specified location, file name, and file type
    - Modify the given file
    - Delete the given file
    - Establish a network connection and transmit data

This program allows us to test an EDR agent and verify it generates the appropriate telemetry.

## Compatibility

    - Linux
    - MacOS

## Installation

This application is not intended to be an "official" ruby gem. Therefor, to install it, you simply
need to clone the repository:

    $ git clone git@github.com:jrmyward/canary.git

Next, you need to bundle the dependencies and install the gem locally:

    $ cd canary
    $ bundle
    $ bundle exec rake install

Finally, to view the available commands:

    $ bundle exec canary --help

## Usage

The program is configured to run with sensible defaults. To quickly see telemetry, simply execute:

    $ bundle exec canary initiate_telemetry

The associated log can be viewed with:

    $ cat log/test_telemetry.log

The `initiate_telemetry` command defines two command-line arguments. You may view these arguments with:

    $ bundle exec canary initiate_telemetry -h

For example, if you would like to change the file, you could run:

    $ bundle exec canary initiate_telemetry --file="~/not_an_actual_image.jpg"

## How it Works

The core functionality of this application exists in the various initiators. The CLI command simply calls the `initiate_all` method in `Canary::ActivityInitiator`. This method orchestrates and logs various initiated activities, providing a way to observe and record telemetry data for each activity performed. Additionally, `Canary::ActivityInitiator` creates an instance of `Canary::ActivityLogger` which serves as a queue for log entries and provides a means to output those entries to a log file. Each specific activity is handled by a dedicated class.

### Process Activity

The `ProcessActivityInitiator` class is responsible for initiating a process activity, executing a specified command, and recording telemetry data related to the process. The call method executes the command using `Open3`.`capture3`, captures output and status, and logs telemetry data by enqueuing the log entry using the provided logger. The telemetry data includes timestamp, username, process ID, process name, and the command line used to initiate the process. The class is designed for integration with an activity logger to maintain a record of executed processes and their details.

Currently, the process metadata (id, name, cmd_line) are associtated with initiating program, that is the Canary gem itself. `Open3` gives us a `stauts` object where we can obtain the spawned process' `pid` and we can intuit the `process_cmd_line` from the given command. However, `Open3` does not provide a means of obtaining the `process_name`.

### File Activity

The `FileActivityInitiator` class is designed to perform various activities on a specified file, such as creating, deleting, and modifying its content. The class utilizes an instance of `ActivityLogger` to record telemetry data for each activity. Public methods (`create_file`, `delete_file`, `modify_file`) perform the respective activities, log the telemetry data, and enqueue the log entry using the provided logger. The telemetry data includes timestamp, username, process ID, process name, command line, file path, and the type of file activity.

### Network Activity

The `NetworkActivityInitiator` class is designed to perform network activities by establishing a TCP socket connection to a specified hostname and port and sending data over the connection. Telemetry data for the network activity is collected and logged using an instance of `ActivityLogger`. The telemetry data includes timestamp, username, process ID, process name, command line, destination and source IP addresses, ports, bytes sent, and the network protocol.

### Logging

The `ActivityLogger` class provides a simple and flexible way to log activity entries to a defined file. This implementation works well for a relatively small expected amount of entries. However, if the program was expected to generate a large number of entries, this implementation could lead to high memory usage.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/canary.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
