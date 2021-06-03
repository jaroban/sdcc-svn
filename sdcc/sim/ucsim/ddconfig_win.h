/* ddconfig_win.h. Configuration for Windows builds (not generated) */

#ifndef DDCONFIG_WIN_HEADER
#define DDCONFIG_WIN_HEADER

#define TYPE_BYTE char
#define TYPE_WORD short
#define TYPE_DWORD int
#define TYPE_QWORD long int

#define UCSOCKET_T int
#define VERSIONSTR "0.6-pre69"

/* Define WORDS_BIGENDIAN to 1 if your processor stores words with the most
   significant byte first (like Motorola and SPARC, unlike Intel). */
#if defined AC_APPLE_UNIVERSAL_BUILD
# if defined __BIG_ENDIAN__
#  define WORDS_BIGENDIAN 1
# endif
#else
# ifndef WORDS_BIGENDIAN
#  undef WORDS_BIGENDIAN
# endif
#endif

/* ucsim custom defines */
#define DD_TRUE     1
#define DD_FALSE    0
#define NIL         0

#endif /* DDCONFIG_WIN_HEADER */
