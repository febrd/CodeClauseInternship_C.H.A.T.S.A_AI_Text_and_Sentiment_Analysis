defmodule FebrdBotWeb.ChatLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form
  alias FebrdBot.Filter

  def render(assigns) do
    language_options = [
      {"Auto", "auto"},
      {"Indonesian", "id"},
      {"English", "en"},
      {"French", "fr"},
      {"Arabic", "ar"},
      {"Czech", "cs"},
      {"German", "de"},
      {"Spanish", "es"},
      {"Estonian", "et"},
      {"Finnish", "fi"},
      {"Gujarati", "gu"},
      {"Hindi", "hi"},
      {"Italian", "it"},
      {"Japanese", "ja"},
      {"Kazakh", "kk"},
      {"Korean", "ko"},
      {"Lithuanian", "lt"},
      {"Latvian", "lv"},
      {"Burmese", "my"},
      {"Nepali", "ne"},
      {"Dutch", "nl"},
      {"Romanian", "ro"},
      {"Russian", "ru"},
      {"Sinhala", "si"},
      {"Turkish", "tr"},
      {"Vietnamese", "vi"},
      {"Chinese", "zh"},
      {"Afrikaans", "af"},
      {"Azerbaijani", "az"},
      {"Bengali", "bn"},
      {"Persian", "fa"},
      {"Hebrew", "he"},
      {"Croatian", "hr"},
      {"Georgian", "ka"},
      {"Khmer", "km"},
      {"Macedonian", "mk"},
      {"Malayalam", "ml"},
      {"Mongolian", "mn"},
      {"Marathi", "mr"},
      {"Polish", "pl"},
      {"Pashto", "ps"},
      {"Portuguese", "pt"},
      {"Swedish", "sv"},
      {"Swahili", "sw"},
      {"Tamil", "ta"},
      {"Telugu", "te"},
      {"Thai", "th"},
      {"Tagalog", "tl"},
      {"Ukrainian", "uk"},
      {"Urdu", "ur"},
      {"Xhosa", "xh"},
      {"Galician", "gl"},
      {"Slovene", "sl"}
    ]

    selected_language = assigns.language

    ~H"""
    <div id="chat-container">
      <header id="chat-header">
        <h1>Febrd Bot - C.H.A.T.S.A</h1>
      </header>
      <div id="chat-box">

        <div id="messages">
        <%= if length(@messages) == 0 do %>
           <div class="message bot-message">
          <p> <strong> Welcome to Febrd Bot!</strong>This bot leverages SpaCy for natural language analysis and LangDetect for automatic language detection. For sentiment analysis, we use TextBlob and VADER Sentiment Analysis, ensuring responses that align with user emotions.</p>
          </div>
          <div class="message bot-message">
          <p> <strong>Made with Love by Febriansah Dirgantara!</strong> with Elixir, Python and Phoenix Framework.</p>
          </div>
          <%else%>
          <%= for {message, response} <- Enum.reverse(@messages) do %>
            <div class="message user-message">
              <strong></strong>
              <p> <%= message %></p>
            </div>
            <div class="message bot-message">
              <strong></strong>
              <p> <%= response %></p>
            </div>
          <% end %>
          <%end%>
        </div>
      </div>
      <form phx-submit="send_message" id="message-form">
        <input type="text" name="message" placeholder="Type your message" autofocus autocomplete="off" required/>
        <button type="submit" disabled={@thinking}>Send</button>
      </form>
      <div id="language-selection" phx-show={@show_language_selection}>
        <p>Select a language:</p>
        <form phx-submit="set_language">
          <select name="language">
            <%= options_for_select(language_options, selected_language) %>
          </select>
          <button type="submit">Apply Language</button>
        </form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    initial_messages = []

    {:ok, assign(socket, messages: initial_messages, show_language_selection: true, language: "Indonesian", thinking: false)}
  end

  def handle_event("set_language", %{"language" => language_code}, socket) do
    IO.inspect(language_code, label: "Language Code")

    language = case language_code do
      "auto" -> "Auto"
      _ -> language_code
    end

    IO.inspect(language, label: "Assigned Language")

    {:noreply, assign(socket, show_language_selection: false, language: language)}
  end
  def handle_event("send_message", %{"message" => message}, socket) do
    if Filter.check_message(message) do
      response = "Inappropriate or Bad content cannot proceed"
      messages = [{message, response} | socket.assigns.messages]
      {:noreply, assign(socket, messages: messages, thinking: false)}
    else
    temp_message = {message, "thinking..."}
    messages = [temp_message | socket.assigns.messages]
    socket = assign(socket, messages: messages, thinking: true)
    Task.async(fn ->
      try do
        python_response = call_python_script(message, socket.assigns.language)
        send(self(), {:update_message, message, python_response})
      rescue
        e -> IO.puts("Task failed: #{inspect(e)}")
      end
    end)


    {:noreply, socket}
  end
  end

  def handle_info({:update_message, original_message, {python_response, detected_language}}, socket) do
    IO.puts("Handling update_message...")
    IO.inspect({original_message, python_response, detected_language})

    updated_messages =
      Enum.map(socket.assigns.messages, fn
        {^original_message, "thinking..."} -> {original_message, python_response}
        other -> other
      end)

    final_messages =
      if detected_language do
        detected_message = {"Detected Language: #{detected_language}", "bot"}
        [detected_message | updated_messages]
      else
        updated_messages
      end
    IO.puts("Final messages:")
    IO.inspect(final_messages)

    {:noreply, assign(socket, messages: final_messages, thinking: false)}
  end


  def handle_info(:done_thinking, socket) do
    {:noreply, assign(socket, thinking: false)}
  end

  def handle_info(message, socket) do
    extracted_message =
      case message do
        {_, actual_message} -> actual_message
        _ -> message
      end

    case extracted_message do
      {:update_message, original_message, {python_response, detected_language}} ->
        handle_update_message(original_message, python_response, detected_language, socket)

      _ ->
        #IO.puts("Received unexpected message: #{inspect(extracted_message)}")
        {:noreply, socket}
    end
  end

  def handle_update_message(original_message, python_response, detected_language, socket) do
    updated_messages =
      Enum.map(socket.assigns.messages, fn
        {^original_message, "thinking..."} -> {original_message, python_response}
        other -> other
      end)
    final_messages =
      if detected_language do
        detected_message = "Detected Language: #{detected_language} - #{python_response}"
        [detected_message | updated_messages]
      else
        updated_messages
      end

    IO.puts("Memory messages:")
    IO.inspect(final_messages)

    {:noreply, assign(socket, messages: final_messages, thinking: false)}
  end


  defp call_python_script(message, language) do
    escaped_message = String.replace(message, "'", "\\'")
    escaped_language = String.replace(language, "'", "\\'")

    command = "python3 lib/febrd_bot_web/live/script/init.py '#{escaped_message}' '#{escaped_language}'"
    {output, _error} = System.cmd("sh", ["-c", command], stderr_to_stdout: true)
    response_data =
      output
      |> String.split("\n")
      |> Enum.reduce(%{response: "No response found", detected_language: nil}, fn line, acc ->
        cond do
          String.starts_with?(line, "Response:") ->
            response = String.trim_leading(line, "Response:")
            %{acc | response: response}

          String.starts_with?(line, "Detected Language:") ->
            detected_language = String.trim_leading(line, "Detected Language:")
            %{acc | detected_language: detected_language}

          true -> acc
        end
      end)

    {response_data.response, response_data.detected_language}
  end


end
