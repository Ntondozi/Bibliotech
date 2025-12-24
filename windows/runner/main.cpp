#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"
#include "resource.h" // Pour l'icône

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') ou créer une nouvelle console si en debug
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialiser COM
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");
  std::vector<std::string> command_line_arguments = GetCommandLineArguments();
  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  // Charger l'icône
  HICON hIcon = (HICON)LoadImage(
      GetModuleHandle(nullptr),
      MAKEINTRESOURCE(IDI_APP_ICON),
      IMAGE_ICON,
      0,
      0,
      LR_DEFAULTSIZE | LR_SHARED
  );

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);

  if (!window.Create(L"kshieldauth", origin, size)) {
    return EXIT_FAILURE;
  }

  // Assigner l'icône à la fenêtre (corrigé pour FlutterWindow récent)
  SendMessage(window.GetHandle(), WM_SETICON, ICON_SMALL, (LPARAM)hIcon);
  SendMessage(window.GetHandle(), WM_SETICON, ICON_BIG, (LPARAM)hIcon);

  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
