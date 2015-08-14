syn region texComment start="\\comment{" skip="%.*$" end="}%$"
syn region texZone	start="\\begin{Verbatim}" end="\\end{Verbatim}\|%stopzone\>" fold
syn region texComment	start="\\begin{comment}" end="\\end{comment}\|%stopzone\>" fold
