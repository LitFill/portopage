struct media-query
  condition: string
  rules: list<style-rule>

struct style-rule
  selector: list<string>
  properties: list<(string, string)>

type css-item
  CssRule(rule: style-rule)
  CssMedia(mq: media-query)

struct style-sheet
  items: list<css-item>

fun validate(s: string): string
  s.replace-all(";", "")
   .replace-all("{", "")
   .replace-all("}", "")
   .replace-all(":", "")

fun validate-condition(s: string): string
  s.replace-all(";", "")
   .replace-all("{", "")
   .replace-all("}", "")

fun rule/show(r: style-rule): string
  if r.selector.is-empty || r.properties.is-empty then ""
  else
    r.selector.join(", ") ++ " {\n" ++ r.properties.map(fn(p)
      "  " ++ validate(p.fst) ++ ": " ++ validate(p.snd) ++ ";\n"
    ).join("") ++ "}\n"

fun indented-rule/show(r: style-rule): string
  "  " ++ r.selector.join(", ") ++ " {\n" ++
    r.properties.map(fn(p)
      "    " ++ validate(p.fst) ++ ": " ++ validate(p.snd) ++ ";\n"
    ).join("") ++ "  }\n"

fun media-query/show(mq: media-query): string
  "@media " ++ validate-condition(mq.condition) ++ " {\n" ++
    mq.rules.map(indented-rule/show).join("") ++
  "}\n"

fun css-item/show(it: css-item): string
  match it
    CssRule(r) -> rule/show(r)
    CssMedia(mq) -> media-query/show(mq)

fun stylesheet/show(s: style-sheet): string
  s.items.map(css-item/show).join("\n")

effect stylesheet-builder
  fun add-rule_(r: style-rule): ()
  fun add-media-query_(mq: media-query): ()

effect style-builder
  fun add-property(key: string, value: string): ()
  fun add-selector(selector: string): ()

fun stylesheet(build-tree: () -> <stylesheet-builder|e> ()): e style-sheet
  var items := []
  with handler
    fun add-rule_(r)
      items := Cons(CssRule(r), items)
    fun add-media-query_(mq)
      items := Cons(CssMedia(mq), items)
    return(_)
      Style-sheet(items.reverse)
  build-tree()

fun add-rule(f: () -> <style-builder,stylesheet-builder|e> ()): <stylesheet-builder|e> ()
  var properties := []
  var selectors := []
  with handler
    fun add-property(key, value)
      properties := Cons((key,value), properties)
    fun add-selector(sel)
      selectors := Cons(sel, selectors)
    return(_)
      add-rule_(Style-rule(selectors, properties.reverse))
  f()

fun add-media-query(condition: string, f: () -> <style-builder,stylesheet-builder|e> ()): <style-builder,stylesheet-builder|e> ()
  var inner-rules := []
  with override
    fun add-rule_(r)
      inner-rules := Cons(r, inner-rules)
    fun add-media-query_(_)
      ()
    return(x)
      add-media-query_(Media-query(condition, inner-rules.reverse))
  f()

fun main()
  val css = stylesheet
    add-rule
      add-selector("body")
      add-property("margin", "0")
      add-property("font-family", "sans-serif")

    add-rule
      add-media-query("(max-width: 768px)")
        add-rule
          add-selector(".container")
          add-selector(".wrapper")
          add-property("padding", "1rem")
        add-rule
          add-selector("h1")
          add-property("font-size", "1.5rem")

  println(css.show)
