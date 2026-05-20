import grammar from "./pddl.tmLanguage.json" with { type: "json" };

/**
 * PDDL (Planning Domain Definition Language) TextMate grammar.
 *
 * Compatible with Shiki, Expressive Code and any pipeline that accepts a
 * `LanguageRegistration`-shaped object. No runtime dependency on `shiki`.
 */
export default grammar as unknown as {
  name: string;
  scopeName: string;
  fileTypes?: string[];
  aliases?: string[];
  patterns: readonly unknown[];
  repository?: Record<string, unknown>;
};
