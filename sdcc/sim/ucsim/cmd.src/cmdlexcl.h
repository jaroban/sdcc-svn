#ifndef CMDLEXCL_HEADER
#define CMDLEXCL_HEADER

#ifdef __cplusplus
extern "C" {
#endif

int yylex();
int yyparse();
void uc_yy_set_string_to_parse(const char *cmdstr);
void uc_yy_free_string_to_parse();

#ifdef __cplusplus
}
#endif

#endif
