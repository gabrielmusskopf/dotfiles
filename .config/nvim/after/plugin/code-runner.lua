require('code_runner').setup({
    project = {
		["~/github.com/unisinos/algoritmos-e-programacao/cinema_lab"] = {
			name = "Cinema",
			command = "cd $dir && javac $fileName && java $fileNameWithoutExt"
		},
	},
    filetype = {
        java = {
            "cd $dir &&",
            "javac $fileName &&",
            "java $fileNameWithoutExt"
        },
        python = "python3 -u",
        typescript = "deno run",
        rust = {
            "cd $dir &&",
            "rustc $fileName &&",
            "$dir$fileNameWithoutExt"
        },
    },
})
