#ifndef _LINUX_WINDOWS_H_
#define _LINUX_WINDOWS_H_

#if defined(_WIN32)

#define strdup _strdup
#define STRNCPY_S(dest, dest_size, src, src_size) strncpy_s(dest, dest_size, src, src_size)
#define FOPEN_S(file_p, file_name, mode) fopen_s(file_p, file_name, mode)
#define FILENO _fileno
#define SPRINTF_S sprintf_s
#define STRCASECMP _stricmp
#define STRNCASECMP _strnicmp

#else

#define strdup strdup
#define STRNCPY_S(dest, dest_size, src, src_size) strncpy(dest, src, src_size)
#define FOPEN_S(file_p, file_name, mode) (((*(file_p)) = fopen(file_name, mode)) == NULL)
#define FILENO fileno
#define SPRINTF_S(buffer, buffer_size, format, ...)  sprintf(buffer, format, __VA_ARGS__)
#define STRCASECMP strcasecmp
#define STRNCASECMP strncasecmp

#endif

#endif
