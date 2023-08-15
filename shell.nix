{ pkgs }:

pkgs.mkShell {
  name = "kal.rkt";

  buildInputs = with pkgs; [
    racket
  ];
}
