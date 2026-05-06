/*----------------------------------------------------------------------------
   Copyright 2024, Koka-Community Authors

   Licensed under the MIT License ("The License"). You may not
   use this file except in compliance with the License. A copy of the License
   can be found in the LICENSE file at the root of this distribution.
----------------------------------------------------------------------------*/

import std/core/string

pub fun html-escape(s: string): string
  s.replace-all("&", "&amp;")
   .replace-all("<", "&lt;")
   .replace-all(">", "&gt;")
   .replace-all("\"", "&quot;")
   .replace-all("'", "&#39;")
