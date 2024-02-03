Function Get-ProjectType {
    $type=Read-Host "
    Comment

    1 - Build: Cambios que afectan el sistema de compilacion o las dependencias externas
    2 - CI: Cambios en nuestros archivos y scripts de configuracion de CI
    3 - Docs: Solo cambios en la documentacion
    4 - Feat: Una nueva caracteristica
    5 - Fix: Una correccion de errores
    6 - Perf: Un cambio de codigo que mejora el rendimiento
    7 - Refactor: Un cambio de codigo que no corrige un error ni agrega una caracteristica
    8 - Style: Cambios que no afectan el significado del codigo
    9 - Test: Adicion de pruebas faltantes o correccion de pruebas existentes
    
    Choose option"
    Switch ($type){
        1 {$choice="Build:"}
        2 {$choice="CI:"}
        3 {$choice="Docs:"}
        4 {$choice="Feat:"}
        5 {$choice="Fix:"}
        6 {$choice="Perf:"}
        7 {$choice="Refactor:"}
        8 {$choice="Style:"}
        9 {$choice="Test:"}
    }
    return $choice
}
$CommentType=Get-ProjectType
git pull
$DefaultMessage = "Just another commit"
Write-Host -Foregroundcolor DarkCyan "Input Message or leave default"
$CommitMessage = if($CommitMessage = (Read-Host "Commit message -Default: $DefaultMessage]")){$CommitMessage}else{$DefaultMessage}
$PushMessage = "$CommentType $CommitMessage"
git add .
git commit -am "$PushMessage"
git push
