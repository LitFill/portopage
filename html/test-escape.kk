import html/core-components
import html/html-builder

fun main()
  val page = handle(fn() {
    html(fn() {
      text("<script>alert('xss')</script>")
    })
  }) {
    fun register-child(t) t
    fun add-attr(k, v) ()
    fun set-bool-attr(k, b) ()
    fun add-class(c) ()
    return(x) x
  }
  println(page.show)
