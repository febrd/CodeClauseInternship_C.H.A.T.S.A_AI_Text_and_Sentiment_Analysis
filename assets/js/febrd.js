document.addEventListener('DOMContentLoaded', () => {
  const messagesContainer = document.getElementById('messages');

  // Function to scroll to the bottom
  const scrollToBottom = () => {
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  };

  // Scroll to bottom initially
  scrollToBottom();

  // Use MutationObserver to handle dynamically added messages
  const observer = new MutationObserver(() => {
    scrollToBottom();
  });

  observer.observe(messagesContainer, { childList: true });

  // Toggle dark/light mode
  const lightModeButton = document.getElementById('light-mode');
  const darkModeButton = document.getElementById('dark-mode');
  const body = document.body;
  const chatContainer = document.getElementById('chat-container');

  lightModeButton.addEventListener('click', () => {
    body.style.backgroundColor = '#f0f2f5';
    chatContainer.style.backgroundColor = '#ffffff';
    lightModeButton.classList.add('active');
    darkModeButton.classList.remove('active');
  });

  darkModeButton.addEventListener('click', () => {
    body.style.backgroundColor = '#333';
    chatContainer.style.backgroundColor = '#444';
    lightModeButton.classList.remove('active');
    darkModeButton.classList.add('active');
  });
});
