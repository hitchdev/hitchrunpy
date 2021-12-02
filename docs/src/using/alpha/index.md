---
title: Using HitchRunPy
---

{% for dirfile in (subdir("using/alpha/").ext("md") - subdir("using/alpha/").named("index.md"))|sort() -%}
- [{{ title(dirfile) }}]({{ dirfile.name.splitext()[0] }})
{% endfor %}
