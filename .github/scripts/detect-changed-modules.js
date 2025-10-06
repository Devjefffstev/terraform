#!/usr/bin/env node

/**
 * Script to detect changed Terraform modules from a list of file paths
 * Usage: node detect-changed-modules.js "file1 file2 file3" [prefix_path]
 */

const fs = require('fs');
const path = require('path');

// Get command line arguments
const args = process.argv.slice(2);
const paths = args[0] || '';
const prefix_path = args[1] || process.env.PATH_PREFIX || 'modules';

// Use stderr for debugging so it doesn't interfere with GitHub Actions output
console.error(`prefix_path: ${prefix_path}`);
console.error(`Paths: ${paths}`);

// Regex to match modules with provider/module pattern
const regex = new RegExp(`${prefix_path}\\/([^/]+\\/[^/]+)`, 'g');
const matches = paths.match(regex);

console.error(`regex: ${regex}`);
console.error(`Found matches: ${matches}`);

if (!matches) {
    console.log('[]');
    process.exit(0);
}

// Extract the module names from the matches
const moduleNames = matches.map(match => {
    return match; // Extract the entire match
});

// Remove duplicates and return the unique module names
const uniqueModuleNames = Array.from(new Set(moduleNames));
console.error(uniqueModuleNames);

// Output as JSON for GitHub Actions (only this goes to stdout)
console.log(JSON.stringify(uniqueModuleNames));