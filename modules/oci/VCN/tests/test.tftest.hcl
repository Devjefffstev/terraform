run "planing" {
  command = plan

  module {
    source = "./"
  }
}
run "applying" {
  command = apply

  module {
    source = "./"
  }
}
