First page <!-- (custom html tag NEEDS the empty line) -->

<br-page/>
Second page <!-- (custom html tag NEEDS the empty line) -->

<page-br/>
Third page <!-- (used by OpenProject and CKEditor) -->
<br style="page-break-before: always;"/>
Fourth page <!-- (used by many editors) -->
<div style="page-break-before: always;">Everything here <br-page/> is ignored</div>
Fifth page <!-- (CKEditor default format) -->
<div class="page-break" style="page-break-before: always;"><span style="display: none"></span></div>
Sixth page
