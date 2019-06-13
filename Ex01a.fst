module Ex01a

type filename = string

let canWrite (f : filename) =
  match f with
    | "demo/tempfile" -> true
    | _ -> false

let canRead (f : filename) =
  canWrite f
  || f = "demo/README"
