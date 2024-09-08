
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Analysis/CallGraph.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/GraphWriter.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/IR/LegacyPassManager.h"


using namespace llvm;

namespace {
    struct CallGraphPass : public ModulePass 
    {
        static char ID;
        CallGraphPass() : ModulePass(ID) {}

        void DumpCallGraph(CallGraph &CG, const std::string &FileName)
        {
            std::error_code EC;
            raw_fd_ostream File(FileName, EC, sys::fs::OF_Text);

            if (!EC) 
            {
                File << "digraph CallGraph {\n";
                std::set<std::pair<std::string, std::string>> uniqueEdges;
                
                for (auto &node : CG) 
                {
                    const Function *F = node.first;
                    if (!F || F->isDeclaration()) continue;

                    std::string FuncName = F->getName().str();
                    File << "\"" << FuncName << "\";\n";

                    CallGraphNode *CGN = node.second.get();
                    for (unsigned i = 0; i < CGN->size(); ++i) 
                    {
                        CallGraphNode *CalleeNode = CGN->operator[](i);
                        Function *Callee = CalleeNode->getFunction();
                        if (Callee && !Callee->isDeclaration()) 
                        {
                            std::string CalleeName = Callee->getName().str();
                            if (uniqueEdges.insert({FuncName, CalleeName}).second) 
                            {
                                File << "\"" << FuncName << "\" -> \"" << CalleeName << "\";\n";
                            }
                        }
                    }
                }

                File << "}\n";
                errs() << "Call graph saved to " << FileName << "\n";
            } 
            else {
                errs() << "Error opening file: " << EC.message() << "\n";
            }
        }

        bool runOnModule(Module &M) override 
        {

            CallGraph CG(M);

            for (auto &node : CG) 
            {
                const Function *F = node.first;
                if (!F || F->isDeclaration()) continue;

                errs() << "Function: " << F->getName() << "\n";


                CallGraphNode *CGN = node.second.get();
                for (unsigned i = 0; i < CGN->size(); ++i) 
                {
                    CallGraphNode *CalleeNode = CGN->operator[](i);
                    Function *Callee = CalleeNode->getFunction();
                    if (Callee && !Callee->isDeclaration()) 
                    {
                        errs() << "  calls " << Callee->getName() << "\n";
                    }
                }
            }

            DumpCallGraph (CG, "callgraph.dot");
            return false;
        }
    };
}

char CallGraphPass::ID = 0;
static RegisterPass<CallGraphPass> X("CGpass", "Call Graph Pass", false, false);


static llvm::RegisterStandardPasses Y(
    llvm::PassManagerBuilder::EP_EarlyAsPossible,
    [](const llvm::PassManagerBuilder &Builder,
       llvm::legacy::PassManagerBase &PM) { PM.add(new CallGraphPass()); });

