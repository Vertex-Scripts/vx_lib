import fs from "fs"
import path from "path"

function scanDir(dir) {
   const results = []
   const files = fs.readdirSync(dir)

   for (const file of files) {
      const fullPath = path.join(dir, file)
      const stat = fs.statSync(fullPath)

      if (stat.isDirectory()) {
         results.push(...scanDir(fullPath))
      } else if (file.endsWith(".lua")) {
         results.push(fullPath)
      }
   }

   return results
}

function findVXFunctions(content) {
   const results = []

   // Pattern for function declaration
   const patterns = [
      /function\s+(vx\.[a-zA-Z0-9_.]+)\((.*?)\)/g,
      /(vx\.[a-zA-Z0-9_.]+)\s*=\s*function\s*\((.*?)\)/g
   ]

   for (const pattern of patterns) {
      let match
      while ((match = pattern.exec(content)) !== null) {
         const name = match[1]
         const args = match[2].split(",").map(a => a.trim()).filter(Boolean)

         // Try to find a doc comment immediately before the function
         const before = content.slice(0, match.index)
         const docMatch = before.match(/(?:--\[\[(.*?)\]\]|--(.*?))\s*$/s)
         const doc = docMatch ? (docMatch[1] || docMatch[2]).trim() : null

         results.push({ name, args, doc })
      }
   }

   return results
}

const luaFiles = scanDir("./")
const functions = {}

for (const file of luaFiles) {
   const content = fs.readFileSync(file, "utf8")
   const vxFunctions = findVXFunctions(content)

   for (const fn of vxFunctions) {
      functions[fn.name] = {
         file,
         args: fn.args
      }
   }
}

console.log(functions)