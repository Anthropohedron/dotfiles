#!/usr/bin/env pwsh

add-type "using System;`n using System.Runtime.InteropServices;`n public class PInvoke { [DllImport(`"user32.dll`")] public static extern bool SetSysColors(int cElements, int[] lpaElements, int[] lpaRgbValues); }"

[PInvoke]::SetSysColors(1, @(1), @(0x2E0E0E))
