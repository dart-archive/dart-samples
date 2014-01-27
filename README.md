# Dart By Example

Short snippets of code to help you become productive with Dart.

See the [source on Github](https://github.com/dart-lang/dart_by_example/tree/master/example).

## Angular Dart

### Basics
* [Setting up a controller](example/angular/basics/setting_up_a_controller)
* [Using multiple controllers](example/angular/basics/using_multiple_controllers)
* [Conditionally displaying content](example/angular/basics/conditionally_displaying_content)
* [Conditionally switching between DOM element](example/angular/basics/conditionally_switch_between_dom_elements)
* [Displaying items in a list](example/angular/basics/displaying_items_in_a_list)
* [Setting element classes using a string](example/angular/basics/setting_element_classes_using_a_string)
* [Setting element classes using a list](example/angular/basics/setting_element_classes_using_a_list)
* [Setting element classes using a map](example/angular/basics/setting_element_classes_using_a_map)

### Components
* [Creating a simple component](example/angular/components/creating_a_simple_component)
* [Applying outside styles to a component](example/angular/components/applying_outside_styles_in_a_component)
* [Adding an element into the Shadow DOM](example/angular/components/adding_an_element_into_the_shadow_dom)
* [Binding an attribute to a string](example/angular/components/binding_an_attribute_to_a_string)
* [Creating a one-way binding](example/angular/components/creating_a_one_way_binding)
* [Creating a one-way one-time binding](example/angular/components/creating_a_one_way_one_time_binding)
* [Creating a two-way binding](example/angular/components/creating_a_two_way_binding)
* [Creating a component that allows child tags](example/angular/components/creating_a_component_that_allows_child_tags)
* [Creating a component that allows only select child tags](example/angular/components/creating_a_component_that_allows_only_select_child_tags)
* [Creating a component that can be used as table row &lt;tr&gt; ](example/angular/components/component_as_table_row)
* [A list component that creates its items dynamically from data](example/angular/components/list_component_generating_items_from_data)
* [A component that repeats over its child nodes](example/angular/components/component_that_repeats_its_children)

### Forms
* [Binding to a boolean using a checkbox](example/angular/forms/binding_to_a_boolean_using_a_checkbox)
* [Selecting an item from a dropdown](example/angular/forms/selecting_an_item_from_a_dropdown)
* [Binding to text fields](example/angular/forms/binding_to_text_fields)
* [Selecting a radio button](example/angular/forms/selecting_a_radio_button)
* [Selecting multiple checkboxes](example/angular/forms/selecting_multiple_checkboxes)

### Routing
* [Setting up simple routing](example/angular/routing/setting_up_simple_routing)
* [Nesting routes](example/angular/routing/nesting_routes)
* [Accessing the router in the controller](example/angular/routing/accessing_router_in_controller)
* [Accessing route params within components](example/angular/routing/accessing_route_params_within_components)
* [Setting up a default view](example/angular/routing/setting_up_a_default_view)
* [Redirecting to a new route](example/angular/routing/redirecting_to_a_new_route)

### Filters
* [Shortening a list](example/angular/filters/shortening_a_list)
* [Shortening a string](example/angular/filters/shortening_a_string)
* [Filtering list contents based on a string match](example/angular/filters/filtering_list_contents_based_on_a_string_match)
* [Ordering list contents](example/angular/filters/ordering_list_contents)
* [Filtering list contents using a function](example/angular/filters/filtering_list_contents_using_a_function)
* [Ordering list contents by field](example/angular/filters/ordering_list_contents_by_field)
* [Ordering list contents in reverse order](example/angular/filters/ordering_list_contents_in_reverse_order)

### Using Polymer elements
* [Using a Polymer element with an Angular controller](example/angular/using_polymer_elements/using_a_polymer_element_with_an_angular_controller)

##  Dart I/O and command-line apps
* [Introduction](example/dart_io/introduction.md)

### Files, directories, and symlinks
* [Deleting a file, directory, or symlink](example/dart_io/files_directories_and_symlinks/deleting_a_file_directory_or_symlink.dart)
* [Renaming a file, directory, or symlink](example/dart_io/files_directories_and_symlinks/renaming_a_file_directory_or_symlink.dart)
* [Finding the type of a filesystem object](example/dart_io/files_directories_and_symlinks/finding_the_type_of_a_filesystem_object.dart)
* [Getting the parent directory](example/dart_io/files_directories_and_symlinks/getting_the_parent_directory.dart)
* [Creating a file](example/dart_io/files_directories_and_symlinks/files/creating_a_file.dart)
* [Reading a file as a string](example/dart_io/files_directories_and_symlinks/files/reading_a_file_as_a_string.dart)
* [Reading a file as lines](example/dart_io/files_directories_and_symlinks/files/reading_a_file_as_lines.dart)
* [Reading a file as bytes](example/dart_io/files_directories_and_symlinks/files/reading_a_file_as_bytes.dart)
* [Using a stream to read a file](example/dart_io/files_directories_and_symlinks/files/reading_a_file_using_a_stream.dart)
* [Handling errors when reading a file](example/dart_io/files_directories_and_symlinks/files/handling_errors_when_reading_a_file.dart)
* [Writing a string to a file](example/dart_io/files_directories_and_symlinks/files/writing_a_string_to_a_file.dart)
* [Writing bytes to a file](example/dart_io/files_directories_and_symlinks/files/writing_bytes_to_a_file.dart)
* [Using a stream to write to a file](example/dart_io/files_directories_and_symlinks/files/writing_to_a_file_using_a_stream.dart)
* [Creating a directory](example/dart_io/files_directories_and_symlinks/directories/creating_a_directory.dart)
* [Creating a temp directory](example/dart_io/files_directories_and_symlinks/directories/creating_a_temporary_directory.dart)
* [Listing the contents of a directory](example/dart_io/files_directories_and_symlinks/directories/listing_the_contents_of_a_directory.dart)
* [Creating a symlink](example/dart_io/files_directories_and_symlinks/symlinks/creating_a_symlink.dart)
* [Checking if a path represents a symlink](example/dart_io/files_directories_and_symlinks/symlinks/checking_if_a_path_represents_a_symlink.dart)
* [Getting the target of a symlink](example/dart_io/files_directories_and_symlinks/symlinks/getting_the_target_of_a_link.dart)

### HTTP requests and responses
* [Making a GET request](example/dart_io/http/making_a_get_request.dart)
* [Making a POST request](example/dart_io/http/making_a_post_request.dart)
* [Adding custom headers to a request](example/dart_io/http/adding_custom_headers.dart)
* [Making multiple requests to the same server](example/dart_io/http/making_multiple_requests_to_the_same_server.dart)
* [Handling errors when making a request](example/dart_io/http/handling_an_httprequest_error.dart)
* [Getting redirection history](example/dart_io/http/getting_redirection_history.dart)
* [Getting the response body as a string](example/dart_io/http/reading_the_response_body.dart)
* [Getting the response content in binary format](example/dart_io/http/getting_the_response_content_in_binary_format.dart)
* [Getting the response headers](example/dart_io/http/getting_the_response_headers.dart)

### HTTP server
* [Implementing a dead-simple HTTP server](example/dart_io/http_server/implementing_a_dead_simple_http_server.dart)
* [Listing directory contents](example/dart_io/http_server/listing_directory_contents.dart)
* [Serving index.html](example/dart_io/http_server/serving_index_html.dart)
* [Serving a 404](example/dart_io/http_server/serving_a_404.dart)
* [Routing requests based on URL patterns](example/dart_io/http_server/routing_requests_based_on_url_patterns.dart)

### Sockets
* [Using serversockets server](example/dart_io/sockets/using_serversockets_server.dart)
* [Using serversockets client](example/dart_io/sockets/using_serversockets_client.dart)

### Websockets
* [Using websockets server](example/dart_io/websockets/using_websockets_server.dart)
* [Using websockets client](example/dart_io/websockets/using_websockets_client.dart)

### OS and hardware information
* [Getting environment variables](example/dart_io/platform/getting_environment_variables.dart)
* [Identifying the operating system](example/dart_io/platform/identifying_the_operating_system.dart)
* [Getting information about the script being run](example/dart_io/platform/getting_information_about_the_script_being_run.dart)

### Interacting with processes
* [Running a process](example/dart_io/interacting_with_processes/running_a_process.dart)
* [Obtaining the exit code when running a process](example/dart_io/interacting_with_processes/obtaining_the_exit_code_when_running_a_process.dart)

### Working with paths
* [Joining paths](example/dart_io/paths/joining_paths.dart)
* [Parsing a path into components](example/dart_io/paths/parsing_a_path_into_components.dart)
* [Calculating relative paths](example/dart_io/paths/calculating_relative_paths.dart)
* [Converting between a URI and a path](example/dart_io/paths/converting_between_a_uri_and_a_path.dart)
* [Getting information about a file path](example/dart_io/paths/getting_information_about_a_file_path.dart)
* [Getting the path separator for the current platform](example/dart_io/paths/getting_the_path_separator_for_the_current_platform.dart)

###  Other resources
* [Other resources](example/dart_io/other_resources.md)
