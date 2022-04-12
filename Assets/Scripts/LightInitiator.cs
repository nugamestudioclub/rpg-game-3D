using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightInitiator : MonoBehaviour
{
    [SerializeField]
    private Light[] lights;
    
    private Ray ray;
    private RaycastHit hit;

    private TargetStoneComponent[] components;
    private Dictionary<TargetStoneComponent, bool> calledComponents = new Dictionary<TargetStoneComponent, bool>();
    private LayerMask targetLayer;

    private float targetRot;

    // Start is called before the first frame update
    void Start()
    {
        targetRot = transform.parent.localEulerAngles.z;
        targetLayer = LayerMask.GetMask("LightTargeting");
        ray = new Ray();
        components = (TargetStoneComponent[])GameObject.FindObjectsOfType(typeof(TargetStoneComponent));
        foreach(TargetStoneComponent component in components)
        {
            if(component.enabled)
                calledComponents.Add(component, false);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Rotate90()
    {
        this.targetRot += 90;
    }
    private void FixedUpdate()
    {
        foreach(TargetStoneComponent component in components)
        {
            calledComponents[component] = false;
        }

        for(int i =0; i < lights.Length; i++)
        {
            ray.origin = lights[i].transform.position;
            ray.direction = lights[i].transform.forward;
            if(Physics.Raycast(ray,out hit,this.targetLayer))
            {
                TargetStoneComponent component;
                if((component=hit.transform.gameObject.GetComponent<TargetStoneComponent>())!=null||
                    (component= hit.transform.gameObject.GetComponentInChildren<TargetStoneComponent>())!=null)
                {
                    if (!component.IsCalled)
                    {
                        component.Call();
                        
                    }
                    
                    calledComponents[component] = true;

                }

            }
           

        }
        foreach(TargetStoneComponent component in this.calledComponents.Keys)
        {
            
            if (!this.calledComponents[component]&&component.IsCalled)
            {
                print("Component:" + component.gameObject.name);
                component.UnCall();
            }
         
        }
        Vector3 targetVector = new Vector3(this.transform.parent.transform.localEulerAngles.x,this.transform.parent.transform.localEulerAngles.y,targetRot%360);
        this.transform.parent.transform.localEulerAngles = Vector3.Slerp(this.transform.parent.transform.localEulerAngles,targetVector,Time.deltaTime);
    }
}
