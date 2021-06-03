#ifndef _LINUX_WINDOWS_H_
#define _LINUX_WINDOWS_H_

#if defined(_WIN32)

#define STRDUP _strdup
#define STRNCPY_S(dest, dest_size, src, src_size) strncpy_s(dest, dest_size, src, src_size)
#define FOPEN_S(file_p, file_name, mode) fopen_s(file_p, file_name, mode)
#define FILENO _fileno

#else

#define STRDUP strdup
#define STRNCPY_S(dest, dest_size, src, src_size) strncpy(dest, src, src_size)
#define FOPEN_S(file_p, file_name, mode) (((*(file_p)) = fopen(file_name, mode)) == NULL)
#define FILENO fileno

#endif

#endif
